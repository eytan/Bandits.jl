import sys

for line in sys.stdin:
  try:
    T = int(line.split('\t')[3]) % 100
    if T % 100 == 0:
      print line.strip()
  except:
    print line.strip()
