return {
  parse(
    'greplog',
    [[for i in {1..2}; do for date in 202201{01..31} 202202{01..10}; do echo "server \${i} date \${date}"; gunzip -c prod\${i}/production.log-\${date}.gz | grep -aE '\[A\]'; done; done]]
  ),
}
