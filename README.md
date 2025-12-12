# analyzing_asisstent

This is repository about the analysis, colecting the data, creating the tables according to data.

## Docker

Build the image:

```bash
docker build -t oleksandkov/sq1:ref .
```

Run an interactive shell:

```bash
docker run --rm -it oleksandkov/sq1:ref
```

Inside the container you have:

- R: `R` / `Rscript`
- PowerShell: `pwsh` (also available as `powershell`)
- Quarto: `quarto`
- SQLite: `sqlite3`

Examples:

```bash
# Run the EDA script (expects SQ1/data/edmonton_cafes.sqlite to exist)
Rscript SQ1/eda/report_1/eda1.r

# Check Quarto install
quarto --version

# Check sqlite CLI
sqlite3 --version

# Start PowerShell
pwsh
```
