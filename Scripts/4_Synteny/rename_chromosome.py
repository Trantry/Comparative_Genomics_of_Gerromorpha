#!/usr/bin/env python3
"""
rename_chromosome.py (version qui remplace aussi les IDs dans la colonne 9)

Robuste parser for correspondence_table that tokenizes by any whitespace (tabs or spaces).
Does not modify input files; writes *_renamed files into --out-dir/<Species>/

Ajout : remplace aussi les occurrences des anciens IDs dans la colonne 9 (attributs) par les nouveaux IDs.
Remplacement fait sur "mot entier" (heuristique basée sur les caractères autorisés A-Za-z0-9_.:-).

NOUVEAU (options):
--match-basename : si présent, les fichiers de sortie (gff et fasta) utiliseront le même basename
                   (préférer le stem du fasta s'il existe, sinon celui du gff). '_renamed' est ajouté.
--out-name       : force un nom de base personnalisé (remplace --match-basename). Fournir sans extension.
"""

import argparse
import pathlib
import re
import sys
from collections import defaultdict

import pandas as pd  # kept for compatibility if needed, but not used for parsing table


# ------------------ parsing utilities ------------------
def read_species_path_file(path):
    d = {}
    p = pathlib.Path(path)
    if not p.exists():
        raise FileNotFoundError(path)
    with p.open("r", encoding="utf-8") as fh:
        for ln in fh:
            ln = ln.strip()
            if not ln or ln.startswith("#"):
                continue
            parts = ln.split(None, 1)
            if len(parts) < 2:
                continue
            species = parts[0].strip()
            fpath = parts[1].strip()
            d[species] = fpath
    return d


def parse_whitespace_table(path):
    """
    Parse a table where columns are separated by tabs (preferred) or arbitrary whitespace.
    Preserves empty fields when the file is tab-delimited (so empty cells are not lost).
    Falls back to whitespace splitting only if the file doesn't appear tab-delimited.
    Returns rows as list of token-lists.
    """
    import csv

    p = pathlib.Path(path)
    if not p.exists():
        raise FileNotFoundError(path)

    rows = []
    # First attempt: read as tab-separated, preserving empty fields
    with p.open("r", encoding="utf-8", errors="ignore") as fh:
        reader = csv.reader(fh, delimiter="\t")
        for raw_row in reader:
            # remove trailing/leading spaces from each cell but keep empty strings
            row = [cell.strip() for cell in raw_row]
            # skip fully empty lines and comments
            if not row or all(cell == "" for cell in row):
                continue
            if row and row[0].startswith("#"):
                continue
            rows.append(row)

    # If tab-read produced only single-column lines, fall back to whitespace splitting
    if rows and max(len(r) for r in rows) == 1:
        rows = []
        with p.open("r", encoding="utf-8", errors="ignore") as fh:
            for ln in fh:
                line = ln.rstrip("\n").strip()
                if line == "" or line.startswith("#"):
                    continue
                toks = re.split(r"\s+", line)
                rows.append(toks)

    if not rows:
        raise ValueError("Table mapping vide")
    return rows


def build_all_mappings_from_whitespace_table(rows):
    """
    rows: list[list[str]]
    Expect:
      rows[0] -> header line (species names, possibly empty tokens)
      rows[1] -> labels like original_id new_id original_id new_id ...
      rows[2:] -> data rows
    Return: (all_mappings_dict, detected_list)
      all_mappings_dict: header_label -> {original: new}
      detected_list: list of (col, col+1, header_label, n_pairs)
    """
    if len(rows) < 2:
        raise ValueError(
            "Table mapping doit contenir au moins deux lignes (header+labels)"
        )

    header_tokens = rows[0]
    label_tokens = rows[1]
    ncols = max(len(header_tokens), len(label_tokens))
    # pad tokens to ncols
    header = header_tokens + [""] * (ncols - len(header_tokens))
    labels = label_tokens + [""] * (ncols - len(label_tokens))

    mappings = {}
    detected = []
    for c in range(ncols - 1):
        lab_c = labels[c].lower() if c < len(labels) else ""
        lab_c1 = labels[c + 1].lower() if (c + 1) < len(labels) else ""
        if lab_c.startswith("original") and lab_c1.startswith("new"):
            # determine header label: try header[c], then search left then right for nearest non-empty
            hdr = header[c] if c < len(header) else ""
            if not hdr:
                # left
                for L in range(c - 1, -1, -1):
                    if L < len(header) and header[L].strip():
                        hdr = header[L].strip()
                        break
            if not hdr:
                for R in range(c + 1, ncols):
                    if R < len(header) and header[R].strip():
                        hdr = header[R].strip()
                        break
            header_label = hdr if hdr else f"col_{c}"
            # build mapping from subsequent rows
            mapping = {}
            for r in range(2, len(rows)):
                row = rows[r]
                o = row[c].strip() if c < len(row) else ""
                n = row[c + 1].strip() if (c + 1) < len(row) else ""
                # ignore empty original ids
                if o:
                    mapping[o] = n
            mappings.setdefault(header_label, {}).update(mapping)
            detected.append((c, c + 1, header_label, len(mapping)))
    return mappings, detected


# ---------- detection by content ----------
def count_matches_in_fasta(mapping, fasta_path, max_headers=3000):
    if not fasta_path:
        return 0
    p = pathlib.Path(fasta_path)
    if not p.exists():
        return 0
    cnt = 0
    seen = 0
    with p.open("r", encoding="utf-8", errors="ignore") as fh:
        for ln in fh:
            if ln.startswith(">"):
                seen += 1
                hdr = ln[1:].strip()
                if not hdr:
                    continue
                key = hdr.split(None, 1)[0]
                if key in mapping:
                    cnt += 1
                if seen >= max_headers:
                    break
    return cnt


def count_matches_in_gff(mapping, gff_path, max_lines=20000):
    if not gff_path:
        return 0
    p = pathlib.Path(gff_path)
    if not p.exists():
        return 0
    cnt = 0
    seen = 0
    with p.open("r", encoding="utf-8", errors="ignore") as fh:
        for ln in fh:
            if ln.startswith("#"):
                continue
            seen += 1
            parts = ln.rstrip("\n").split("\t")
            if not parts:
                continue
            seqid = parts[0]
            if seqid in mapping:
                cnt += 1
            if seen >= max_lines:
                break
    return cnt


def choose_mapping_by_content(
    all_mappings, fasta_path=None, gff_path=None, debug=False
):
    best = None
    best_score = 0
    scores = {}
    for hdr, mapping in all_mappings.items():
        if not mapping:
            continue
        s = 0
        s += count_matches_in_fasta(mapping, fasta_path)
        s += count_matches_in_gff(mapping, gff_path)
        scores[hdr] = s
        if s > best_score:
            best_score = s
            best = hdr
    if debug:
        print("[DEBUG] content scores (header -> matches):")
        for h, sc in sorted(scores.items(), key=lambda x: -x[1])[:30]:
            print("   ", h, "->", sc)
    if best_score > 0:
        return all_mappings[best]
    return None


# ---------- helpers for attribute replacement ----------
def replace_ids_in_attr(attrstr, mapping):
    """
    Replace occurrences of keys in mapping by mapping[key] inside attrstr.
    Replacement is done on word boundaries using a heuristic: do not match if
    immediately adjacent to characters that are allowed inside IDs.
    NOTE: ':' has been removed from the allowed-chars class so we still match
    IDs appearing between colons (e.g. ...:CM126190.1:...).
    """
    if not attrstr or not mapping:
        return attrstr, 0
    v = attrstr
    replaced_count = 0
    # iterate keys longest-first to avoid partial overlaps (e.g. 'ABC' and 'A')
    for orig in sorted(mapping.keys(), key=len, reverse=True):
        new = mapping[orig]
        if not new:
            continue
        # allowed chars inside IDs: letters, digits, underscore, dot, hyphen
        pattern = r"(?<![A-Za-z0-9_.-])" + re.escape(orig) + r"(?![A-Za-z0-9_.-])"
        v, nsub = re.subn(pattern, new, v)
        replaced_count += nsub
    return v, replaced_count


# ---------- rename functions ----------
def rename_fasta(inpath, outpath, mapping):
    total = 0
    replaced = 0
    p_in = pathlib.Path(inpath)
    with (
        p_in.open("r", encoding="utf-8", errors="ignore") as inf,
        open(outpath, "w", encoding="utf-8") as outf,
    ):
        for ln in inf:
            if ln.startswith(">"):
                total += 1
                hdr = ln[1:].rstrip("\n")
                if not hdr:
                    outf.write(ln)
                    continue
                parts = hdr.split(None, 1)
                key = parts[0]
                rest = parts[1] if len(parts) > 1 else ""
                if key in mapping and mapping[key]:
                    outf.write(
                        ">" + mapping[key] + ((" " + rest) if rest else "") + "\n"
                    )
                    replaced += 1
                else:
                    outf.write(ln)
            else:
                outf.write(ln)
    return total, replaced


def rename_gff(inpath, outpath, mapping, debug=False):
    total = 0
    replaced_seqid = 0
    replaced_attr_total = 0
    p_in = pathlib.Path(inpath)
    with (
        p_in.open("r", encoding="utf-8", errors="ignore") as inf,
        open(outpath, "w", encoding="utf-8") as outf,
    ):
        for ln in inf:
            if ln.startswith("#"):
                outf.write(ln)
                continue
            if ln.strip() == "":
                outf.write("\n")
                continue
            parts = ln.rstrip("\n").split("\t")
            if not parts:
                outf.write(ln)
                continue
            # ensure we can access column 9 safely
            while len(parts) < 9:
                parts.append("")

            seqid = parts[0]
            total += 1
            if seqid in mapping and mapping[seqid]:
                parts[0] = mapping[seqid]
                replaced_seqid += 1

            # replace ids inside attributes (column 9)
            attr = parts[8]
            new_attr, nattr = replace_ids_in_attr(attr, mapping)
            if nattr > 0:
                parts[8] = new_attr
                replaced_attr_total += nattr

            outf.write("\t".join(parts) + "\n")

    if debug:
        print(
            f"[DEBUG] rename_gff: processed={total}, seqid_replaced={replaced_seqid}, attr_replacements={replaced_attr_total}"
        )
    # preserve original return shape: (total, replaced) -> replaced is seqid replacements (compatible with caller)
    return total, replaced_seqid


# ------------------ CLI ------------------
def parse_args():
    ap = argparse.ArgumentParser(
        description="Rename GFF/FASTA using whitespace table parser (also replace IDs inside column 9 attrs)."
    )
    ap.add_argument("--mapping", "-m", required=True, help="correspondence table path")
    ap.add_argument(
        "--genomes",
        required=True,
        help='file listing genomes: "Species <path>" per line',
    )
    ap.add_argument(
        "--gffs", required=True, help='file listing gffs: "Species <path>" per line'
    )
    ap.add_argument("--out-dir", "-o", required=True, help="output root dir")
    ap.add_argument("--skip-missing", action="store_true", help="skip missing")
    ap.add_argument("--debug", action="store_true", help="debug prints")
    # NEW OPTIONS
    ap.add_argument(
        "--match-basename",
        action="store_true",
        help="Make outputs use same basename (except extension). Uses fasta stem if available, otherwise gff stem.",
    )
    ap.add_argument(
        "--out-name",
        help="Custom basename to use for outputs (overrides --match-basename). Provide basename WITHOUT extension; '_renamed' will be appended.",
    )
    return ap.parse_args()


def main():
    args = parse_args()
    out_root = pathlib.Path(args.out_dir)
    out_root.mkdir(parents=True, exist_ok=True)

    genomes = read_species_path_file(args.genomes)
    gffs = read_species_path_file(args.gffs)

    # parse the mapping table robustly by whitespace
    rows = parse_whitespace_table(args.mapping)
    all_mappings, detected = build_all_mappings_from_whitespace_table(rows)
    if args.debug:
        print(
            "[DEBUG] detected mapping pairs (colstart, colend, header_label, n_pairs):"
        )
        for d in detected:
            print("  ", d)
        print("[DEBUG] mapping headers:", list(all_mappings.keys()))

    species_set = set(list(genomes.keys()) + list(gffs.keys()))
    summary = []
    for sp in sorted(species_set):
        print(f"\nTraitement: {sp}")
        sp_out = out_root / sp
        sp_out.mkdir(parents=True, exist_ok=True)

        # 1) try header-based direct selection
        mapping = None
        if sp in all_mappings and all_mappings[sp]:
            mapping = all_mappings[sp]
        else:
            # try substring matches on header labels
            for k in all_mappings:
                if k and (sp == k or sp in k):
                    mapping = all_mappings[k]
                    break
            if mapping is None:
                for k in all_mappings:
                    if k and sp.lower() in k.lower():
                        mapping = all_mappings[k]
                        break

        # 2) if still None, attempt content-based detection
        if mapping is None:
            fasta_p = genomes.get(sp)
            gff_p = gffs.get(sp)
            if not fasta_p and not gff_p:
                print(f"[WARN] pas de fasta ni gff listé pour {sp} -> SKIP")
                summary.append((sp, "no_files"))
                continue
            mapping = choose_mapping_by_content(
                all_mappings, fasta_p, gff_p, debug=args.debug
            )
            if mapping is None:
                print(f"[WARN] Mapping non trouvé pour {sp} -> SKIP")
                summary.append((sp, "mapping_missing"))
                continue
            else:
                print(f"[INFO] Mapping choisi pour {sp} via détection du contenu.")

        # --- New: determine unified basename if requested ---
        unified_basename = None
        if args.out_name:
            unified_basename = args.out_name
        elif args.match_basename:
            # prefer fasta stem if available on the list; else gff stem
            if sp in genomes:
                fasta_path_tmp = pathlib.Path(genomes[sp])
                if fasta_path_tmp.exists():
                    unified_basename = fasta_path_tmp.stem
            if not unified_basename and sp in gffs:
                gff_path_tmp = pathlib.Path(gffs[sp])
                if gff_path_tmp.exists():
                    unified_basename = gff_path_tmp.stem
        # Note: unified_basename does NOT include the '_renamed' suffix; we will append it.

        # apply mapping
        if sp in genomes:
            fasta_path = pathlib.Path(genomes[sp])
            if not fasta_path.exists():
                msg = f"[FASTA] missing: {fasta_path}"
                if args.skip_missing:
                    print(msg)
                    summary.append((sp, "fasta_missing", str(fasta_path)))
                else:
                    print(msg)
                    sys.exit(1)
            else:
                if unified_basename:
                    out_f = sp_out / (unified_basename + "_renamed" + fasta_path.suffix)
                else:
                    out_f = sp_out / (fasta_path.stem + "_renamed" + fasta_path.suffix)
                total_f, replaced_f = rename_fasta(str(fasta_path), str(out_f), mapping)
                print(
                    f"[FASTA] {fasta_path.name} -> {out_f.name} : processed={total_f}, replaced={replaced_f}"
                )
                summary.append((sp, "fasta", str(out_f), total_f, replaced_f))
        else:
            print(f"[FASTA] none listed for {sp}")

        if sp in gffs:
            gff_path = pathlib.Path(gffs[sp])
            if not gff_path.exists():
                msg = f"[GFF] missing: {gff_path}"
                if args.skip_missing:
                    print(msg)
                    summary.append((sp, "gff_missing", str(gff_path)))
                else:
                    print(msg)
                    sys.exit(1)
            else:
                if unified_basename:
                    out_g = sp_out / (unified_basename + "_renamed" + gff_path.suffix)
                else:
                    out_g = sp_out / (gff_path.stem + "_renamed" + gff_path.suffix)
                total_g, replaced_g = rename_gff(
                    str(gff_path), str(out_g), mapping, debug=args.debug
                )
                print(
                    f"[GFF] {gff_path.name} -> {out_g.name} : processed={total_g}, seqid_replaced={replaced_g}"
                )
                summary.append((sp, "gff", str(out_g), total_g, replaced_g))
        else:
            print(f"[GFF] none listed for {sp}")

    print("\n--- Résumé ---")
    for e in summary:
        print(e)


if __name__ == "__main__":
    main()
