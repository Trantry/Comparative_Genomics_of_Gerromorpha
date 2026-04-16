#!/usr/bin/env python3
import re
import sys

# Keep one protein per gene:
# - gene id is everything before "-mRNA-<n>"
# - choose longest sequence
# - tie-break: smallest mRNA number (mRNA-1 wins)

re_header = re.compile(r"^>(\S+)")
re_gene = re.compile(r"^(.*?)-mRNA-(\d+)\b")

best = {}  # gene -> (length, iso_num, header, seq)


def commit(header, seq):
    if header is None:
        return
    seq = seq.replace("\n", "")
    m = re_gene.match(header)
    if not m:
        # If the header doesn't match, keep it as its own "gene"
        gene = header
        iso = 1
    else:
        gene = m.group(1)
        iso = int(m.group(2))

    rec = (len(seq), iso, header, seq)

    # longest wins; tie -> smaller iso number wins
    if gene not in best:
        best[gene] = rec
    else:
        L, I, _, _ = best[gene]
        if rec[0] > L or (rec[0] == L and rec[1] < I):
            best[gene] = rec


header = None
seq_lines = []
for line in sys.stdin:
    line = line.rstrip("\n")
    if line.startswith(">"):
        commit(header, "\n".join(seq_lines))
        header = line[1:].strip()
        seq_lines = []
    else:
        seq_lines.append(line.strip())
commit(header, "\n".join(seq_lines))

# output (order doesn't matter for OrthoFinder; if you want stable order, we can add it)
for gene in best:
    _, _, h, s = best[gene]
    sys.stdout.write(f">{h}\n")
    for i in range(0, len(s), 60):
        sys.stdout.write(s[i : i + 60] + "\n")
