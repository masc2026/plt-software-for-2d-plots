#! /bin/sh
# file: macdemo.sh      M. Schmid             06 March 2026
# This script runs 'plt -T lw' to generate the figures included in the plt -T lw Tutorial
# and Cookbook.

MYDIR=$(cd "$(dirname "$0")" && pwd)

mkdir -p "$MYDIR/out"
OUTPNG="$MYDIR/out/out.png"
OUTPDF="$MYDIR/out/out.pdf"

preview() {
  echo "Figure $1"
  open -g "$2"
  echo "Press Enter to continue"
  read A
  jobs=$(lsof -t "$2")
  for jobid in $jobs ; do
    kill "$jobid"
    rm "$2"
  done
}

if [ "$(uname)" != "Darwin" ]; then
  echo "This test only runs on macOS platform."
  exit 1
fi

cd "$MYDIR/../doc" || exit 1

C=2
F=1
plt -T lw example1.data 0 2 | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "2.1" "$OUTPDF"

cat <<EOF

You should now see figure 2.1 from the plt -T lw Tutorial and Cookbook, in a window
on your screen (look for the window named "plt -T lw Window").  If the window has not
been created, plt -T lw may not have been installed properly on this system; in this
case, please read Appendix D of the plt -T lw Tutorial and Cookbook to see how to
install plt -T lw.  The most recent version of plt -T lw is always available from PhysioNet
(http://www.physionet.org/).
EOF

echo "Figure 2.2 is a screen image, also shown as figure 2.3 in PostScript form."
F=3
plt -T lw heartrate.data | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "2.$F" "$OUTPDF"

(( F=F+1 ))
plt -T lw heartrate.data -t "Heart rate time series" \
 -x "Time (seconds)" -y "Heart rate (beats per minute)" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "2.$F" "$OUTPDF"


(( F=F+1 ))
plt -T lw heartrate.data -t "Heart rate time series" \
 -x "Time (seconds)" -y "Heart rate (beats per minute)" \
 -xa 60 300 15 - 4 -ya 0 80 20 -g grid,sub | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "2.$F" "$OUTPDF"

(( F=F+1 ))
plt -T lw heartrate.data -t "Heart rate time series" \
 -x "Time (seconds)" -y "Heart rate (beats per minute)" \
 -xa 60 300 15 - 4 -ya 0 80 20 -g grid,sub \
 -p 0,1Scircle | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "2.$F" "$OUTPDF"

(( F=F+1 ))
plt -T lw heartrate.data -t "Heart rate time series" \
 -x "Time (seconds)" -y "Heart rate (beats per minute)" \
 -xa 60 300 15 - 4 -ya 0 80 20 -g grid,sub \
 -p "0,1Scircle(P/2,Cblue)" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "2.$F" "$OUTPDF"

(( F=F+1 ))
macpltf 's(40*x)*s(3*x)' 0 5 .01 | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "2.$F" "$OUTPDF"

(( C=3 )); F=1

plt -T lw :s2,1024,2049,1 ecg.dat -cz 8 .00781 -F"p 0,1n(Cred) 0,2n(Cblue)" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( C=4 )); F=1

plt -T lw -f coords.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))
cat <<EOF
Font scaling on the X display does not exactly match PostScript font scaling,
so the next example may appear odd.  See this example in the plt -T lw Tutorial and
Cookbook.
EOF

plt -T lw -f example8.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( C=5 )); F=1

plt -T lw example1.data 0 2\
    -x "time in seconds" -y "amplitude in cm" -t "Time vs Amp" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw example1.data 0 2 -f example3.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))
echo "Hénon attractor:"
./henon | plt -T lw % -p s. -X -1.5 1.5 -Y -.5 .5 -t "Henon Attractor" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( C=6 )); F=1

plt -T lw example4.data 0 1 2 -F"\
    fs helvetica longdashed dotted\
    p c" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw symbols.dat -f symbols.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p "0,1C(G.70)" -t "Plotstyle C" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 0,1,2e+Z -t "Plotstyle e+Z" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 0,1,2e-X -t "Plotstyle e-X" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p "0,1,2e:+" -t "Plotstyle e:+" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 0,1,2E+0 -t "Plotstyle E+0" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p "0,1,2E-ftriangle" -t "Plotstyle E-ftriangle" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p "0,1,2E:square" -t "Plotstyle E:square" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p "0,1,2f(G.70)" -t "Plotstyle f" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 0,1i -t "Plotstyle i" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 0,1,0,3l -t "Plotstyle l" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 1m -t "Plotstyle m" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 0,1n -t "Plotstyle n" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p "0,1N(G.70)" -t "Plotstyle N" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 0,1,2o -t "Plotstyle o" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p "0,1,2O(G.70)" -t "Plotstyle O" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 0,1sO -t "Plotstyle sO" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 0,1Sfdiamond -t "Plotstyle Sfdiamond" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw styles.data -p 0,1,3t -t "Plotstyle t" -ts "Do Re Mi Fa Sol La Ti" CB | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( C=7 )); F=1

plt -T lw example5.data 0 3 0 2 1 -F"p s+ s* m" \
    -x "x axis" -y "y axis" -t "plot of y=x; y=2x and y=3x" | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

(plt -T lw example7.data 0 1 -f example7.format; plt -T lw example7.data 0 2 -f example7.axes -o) | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw example10.data -f example10.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

(plt -T lw ldemo.data 2 3 -t"FREQUENCY RESPONSE OF THE FILTER" \
    -x"FREQUENCY IN HERTZ" -y"THIS IS THE AMPLITUDE" -sf all P16 ; plt -T lw ldemo.data 2 3 -t"FREQUENCY RESP." -x"FREQUENCY" \
    -y"AMPLITUDE"  -W .3 .3 .5 .45 -se -sf all P12; plt -T lw ldemo.data 2 3 -t"FREQUENCY RESPONSE" -x"FREQUENCY" \
    -y"AMPLITUDE"  -W .6 .55 .9 .8 -se  -sf all P14) | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

(plt -T lw -wm 0 -t "This is the main title for the plot"; plt -T lw example11.data 0 1 -wm 1 -t "Window 1") | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

(plt -T lw -wb 0 -t "This is the main title for the plot"; plt -T lw example11.data 0 1 -wb 1 -t "Window 1"; plt -T lw example11.data 0 2 -wb 2 -t "Window 2") | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

(plt -T lw -wq 0 -t "This is the main title for the plot"; plt -T lw example11.data 0 1 -wq 1 -t "Window 1"; plt -T lw example11.data 0 2 -wq 2 -t "Window 2"; plt -T lw example11.data 0 3 -wq 3 -t "Window 3"; plt -T lw example11.data 0 4 -wq 4 -t "Window 4") | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( C=8 )); F=1

plt -T lw example9.data -f example9.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw cos2.data 0 1 -f labels.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( C=9 )); F=1

plt -T lw -f flowchart.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( C=10 )); F=1
(( C=11 )); F=1

plt -T lw -f fonts.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw -f linestyles.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw example14.data -f fontgroup.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw example14.data -f example14.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

plt -T lw -f colors.format | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( C=12 )); F=1

(plt -T lw -wq 0 -t"THE TITLE FOR THE ENTIRE GRAPH GOES HERE"; plt -T lw ldemo.data 2 3 -wqs 1 -lx -g in -t"LPF: Log Freq & Ticks in"; plt -T lw ldemo.data 4 5 -wqs 4 -lx -ly -g both -t"LPF: Log Freq & Ampl"; plt -T lw ldemo.data 0 1 -wqs 3 -lx e -g out  -t"Alternate base & Ticks out"; plt -T lw ldemo.data 6 7 -wqs 2 -lx -ly - yes -g grid,sym,out -t"Log axes with grid") | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

(( F=F+1 ))

(plt -T lw power.data 0 1 2 3 4 5 -f conf1.format; plt -T lw power.data 0 6 7 8 9 10 -f conf2.format) | lwcat -custom 6.45 6.78 0 0 1 -pstopdf > "$OUTPDF"
preview "$C.$F" "$OUTPDF"

cat <<EOF
This concludes the demonstration of plt -T lw.
EOF
exit 0

