# === User Configurations ===
EXEC=../../class                    # hi_class executable built at repository root
BASE_INI=CCDE_CMB.ini             # Base parameter file


# === Parameter sets ===
param_sets=(
 "-3 -1 1 1.5 0.1 1"
 "-3 -1 1 1.5 0.05 1"
 "-3 -1 1 1.5 0.001 1"
"-3 -1 1 1.5 -0.05 1"


 "-3 -13 1 1. 0.1 1"
 "-3 -1 1 1. 0.05 1"
 "-3.2 -1.1 1 1. 0.001 1"
 "-2.1 -0.9 1 1. -0.05 1"
 "-10 -7 1 1. -0.1 1"

 "-3 -2 1 0.3 0.1 1"
  "-3 -2 1 0.3 0.05 1"
  "-3 -2 1 0.3 0.001 1"
  "-1.5 -0.9 1 0.3 -0.05 1"
  "-1.5 -0.9 1 0.3 -0.1 1"

  "-2 -1 1 0.001 0.1 1"
  "-2 -1 1 0.001 0.05 1"
  "-2 -1 1 0.001 0.001 1"
  "-3 -1 1 0.001 -0.05 1"
  "-3 -1 1 0.001 -0.1 1"
)

# === Loop over parameter sets ===
run_id=0
for params in "${param_sets[@]}"; do
    run_id=$((run_id+1))

    # Show progress
    echo "=== Running set $run_id / ${#param_sets[@]} ==="

    # Read parameters into variables
    read phi phiprime lambda sigma alpha phi2today <<< "$params"

    # Create unique output folder
    OUTDIR="run_sigma${sigma}_alpha${alpha}"
    mkdir -p "$OUTDIR"

    # Copy base ini into folder
    cp "$BASE_INI" "$OUTDIR/input.ini"
    echo "
    parameters_smg =   $phi    ,   $phiprime  ,   1.  ,   $sigma  ,   $alpha , 1."  >> "$OUTDIR/input.ini"
    echo "
    root =   $OUTDIR/CCDE_sigma${sigma}_alpha${alpha}"  >> "$OUTDIR/input.ini"
    # Run hi_class with root pointing to output folder
    $EXEC "$OUTDIR/input.ini"  > "$OUTDIR/output.txt"

done

echo "All runs finished."
