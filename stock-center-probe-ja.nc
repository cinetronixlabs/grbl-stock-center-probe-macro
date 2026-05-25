%stockX = 200
%stockY = 100
%probeZ = -2.5
%safeZ = 10.0
%margin = 10.0
%search = 50.0
%fast = 150.0
%slow = 40.0
%retract = 2.0

M0 ; 続行前に、材料天面をGRBL制御ソフトの標準的なZプローブ機能などでZ0に設定してください。材料の左側外側・Y中央付近・Z安全高さから開始します。

G21
G90
G94
M5

G0 Z[safeZ]

; ---- X-側を測定 ----
G0 Z[probeZ]
G91
G38.2 X[search] F[fast]
G0 X[-retract]
G38.2 X[retract * 2] F[slow]
%xMinus = params.PRB.x
G0 X[-retract]
G90
G0 Z[safeZ]

; ---- X+側の外側へ回り込む ----
G91
G0 X[stockX + margin + retract]
G90

; ---- X+側を測定 ----
G0 Z[probeZ]
G91
G38.2 X[-search] F[fast]
G0 X[retract]
G38.2 X[-retract * 2] F[slow]
%xPlus = params.PRB.x
G0 X[retract]
G90
G0 Z[safeZ]

; ---- X方向の中心へ移動 ----
%centerX = (xMinus + xPlus) / 2
%xMoveToCenter = centerX - (xPlus + retract)

([xMinus])
([xPlus])
([centerX])
([xMoveToCenter])

G91
G0 X[xMoveToCenter]
G90

; ---- Y-側の外側へ移動 ----
G91
G0 Y[-(stockY / 2 + margin)]
G90

; ---- Y-側を測定 ----
G0 Z[probeZ]
G91
G38.2 Y[search] F[fast]
G0 Y[-retract]
G38.2 Y[retract * 2] F[slow]
%yMinus = params.PRB.y
G0 Y[-retract]
G90
G0 Z[safeZ]

; ---- Y+側の外側へ回り込む ----
G91
G0 Y[stockY + margin + retract]
G90

; ---- Y+側を測定 ----
G0 Z[probeZ]
G91
G38.2 Y[-search] F[fast]
G0 Y[retract]
G38.2 Y[-retract * 2] F[slow]
%yPlus = params.PRB.y
G0 Y[retract]
G90
G0 Z[safeZ]

; ---- Y方向の中心へ移動 ----
%centerY = (yMinus + yPlus) / 2
%yMoveToCenter = centerY - (yPlus + retract)

([yMinus])
([yPlus])
([centerY])
([yMoveToCenter])

G91
G0 Y[yMoveToCenter]
G90

; ---- 現在位置をXY中心として原点設定 ----
G10 L20 P0 X0 Y0
G0 X0 Y0
G0 Z[safeZ]
