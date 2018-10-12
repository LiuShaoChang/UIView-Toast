# SCToast
这是一个view的extension,想要弹出一个toast只需要一句代码,支持很多样式.后续会支持多种hud.

## 01样式
code:
```
self.view.makeToast("sb,出错了")
```
style:

<div align=center><img src="./images/01.png" alt="图1" title="图1"/></div>

## 02样式
code:
```
self.view.makeToast("洒家不喜欢你", "告示")
```
style:

<div align=center><img src="./images/02.png" alt="图2" title="图2"/></div>

## 03样式
code:
```
self.view.makeToast(UIImage(named: "fast")!)
```
style:

<div align=center><img src="./images/03.png" alt="图3" title="图3"/></div>

## 04样式
code:
```
self.view.makeToast(UIImage(named: "fast"), "路飞", nil, imageRelativePosition: .upDown, position: .center, duration: 10)
```
style:

<div align=center><img src="./images/04.png" alt="图4" title="图4"/></div>

## 05样式
code:
```
self.view.makeToast(UIImage(named: "fast"), "路飞通缉令", "路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长", imageRelativePosition: .leftRight, position: .center, duration: 10)
```
style:

<div align=center><img src="./images/05.png" alt="图5" title="图5"/></div>

## 06样式
code:
```
self.view.makeToast(UIImage(named: "fast"), "路飞通缉令", "路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长,路飞这SB,赏金已经达到15亿贝利,我还能更长", imageRelativePosition: .upDown, position: .center, duration: 10)
```
style:

<div align=center><img src="./images/06.png" alt="图6" title="图6"/></div>

