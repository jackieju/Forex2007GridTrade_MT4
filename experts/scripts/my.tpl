<chart>
symbol=EURUSDm
period=1
leftpos=20202
digits=4
scale=8
graph=1
fore=1
grid=1
volume=1
scroll=1
shift=1
ohlc=1
askline=1
days=1
descriptions=0
shift_size=20
fixed_pos=0
window_left=0
window_top=0
window_right=710
window_bottom=489
window_type=3
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=65280
bullcandle_color=0
bearcandle_color=16777215
chartline_color=65280
volumes_color=3329330
grid_color=10061943
askline_color=65280
stops_color=255

<window>
height=194
<indicator>
name=main
</indicator>
<indicator>
name=Moving Average
period=20
shift=0
method=0
apply=0
color=65535
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=5
shift=0
method=0
apply=0
color=255
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=10
shift=0
method=0
apply=0
color=42495
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=40
shift=0
method=0
apply=0
color=25600
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=80
shift=0
method=0
apply=0
color=16760576
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=120
shift=0
method=0
apply=0
color=8388608
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=600
shift=0
method=0
apply=0
color=8388736
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=LineAlarm
flags=275
window_num=0
<inputs>
AlarmType=1
OnOff=1
Email=1
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=255
style_0=0
weight_0=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=1440
shift=0
method=0
apply=0
color=14020607
style=2
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Moving Average
period=2880
shift=0
method=0
apply=0
color=14020607
style=0
weight=1
period_flags=0
show_data=1
</indicator>
</window>

<expert>
name=Moving Average
flags=403
window_num=0
<inputs>
Lots=0.10000000
MaximumRisk=0.02000000
DecreaseFactor=3.00000000
MovingPeriod=12.00000000
MovingShift=6.00000000
</inputs>
</expert>
</chart>
