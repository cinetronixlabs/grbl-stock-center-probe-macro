%stockX = 200
%stockY = 100
%probeZ = -2.5
%safeZ = 10.0
%margin = 10.0
%search = 50.0
%fast = 150.0
%slow = 40.0
%retract = 2.0

M0 ; Before continuing, set the material top surface as Z0 using a standard Z-probing function or similar feature. Start from outside the left side of the stock, near the Y center, at a safe Z height.

G21
G90
G94
M5

G0 Z[safeZ]

; ---- X- side ----
G0 Z[probeZ]
G91
G38.2 X[search] F[fast]
G0 X[-retract]
G38.2 X[retract * 2] F[slow]
%xMinus = params.PRB.x
G0 X[-retract]
G90
G0 Z[safeZ]

; ---- Move around to the right side ----
G91
G0 X[stockX + margin + retract]
G90

; ---- X+ side ----
G0 Z[probeZ]
G91
G38.2 X[-search] F[fast]
G0 X[retract]
G38.2 X[-retract * 2] F[slow]
%xPlus = params.PRB.x
G0 X[retract]
G90
G0 Z[safeZ]

; ---- Move to X center ----
%centerX = (xMinus + xPlus) / 2
%xMoveToCenter = centerX - (xPlus + retract)

([xMinus])
([xPlus])
([centerX])
([xMoveToCenter])

G91
G0 X[xMoveToCenter]
G90

; ---- Move outside the front side ----
G91
G0 Y[-(stockY / 2 + margin)]
G90

; ---- Y- side ----
G0 Z[probeZ]
G91
G38.2 Y[search] F[fast]
G0 Y[-retract]
G38.2 Y[retract * 2] F[slow]
%yMinus = params.PRB.y
G0 Y[-retract]
G90
G0 Z[safeZ]

; ---- Move around to the back side ----
G91
G0 Y[stockY + margin + retract]
G90

; ---- Y+ side ----
G0 Z[probeZ]
G91
G38.2 Y[-search] F[fast]
G0 Y[retract]
G38.2 Y[-retract * 2] F[slow]
%yPlus = params.PRB.y
G0 Y[retract]
G90
G0 Z[safeZ]

; ---- Move to Y center ----
%centerY = (yMinus + yPlus) / 2
%yMoveToCenter = centerY - (yPlus + retract)

([yMinus])
([yPlus])
([centerY])
([yMoveToCenter])

G91
G0 Y[yMoveToCenter]
G90

; ---- Set current position as XY center ----
G10 L20 P0 X0 Y0
G0 X0 Y0
G0 Z[safeZ]
