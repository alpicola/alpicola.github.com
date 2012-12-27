% contextfree.jsを書いた
% alpicola
% January 1, 2011

Context Freeというフラクタルを記述するのに便利な言語をJavaScriptに移植した。

- [alpicola/contextfree.js](http://github.com/alpicola/contextfree.js)
- [demo](http://alpico.la/contextfree.js/)

Aza Raskinさんがすでに同様のものを作っている([ContextFree.js & Algorithm Ink: Making Art with Javascript « Aza on Design](http://www.azarask.in/blog/post/contextfreejs-algorithm-ink-making-art-with-javascript/))のだけど、これはContext Freeの最低限の要素を実装したもので本家のギャラリー(CFDG Gallery - CFDG Gallery)にあるものなどはほとんど動作せず、描画のアルゴリズムも異なるため動作してもレンダリング結果が違うということが多い(当時の主要ブラウザのJavaScriptの実行速度を考えるとそれが"ベストプラクティス"だったのだろうけど)。

そこで、本家のものとほぼ同等のレンダリングを行えるものを書いた。ただし、フラクタルの展開時に数万、数十万のオブジェクトを生成する場合があるため実行にそれなりの時間を要し、各ブラウザ間でも顕著なパフォーマンスの違いが見られた。上のサンプルだと手元のMacBook Late 2009においてChromeで10秒、FirefoxとSafariで30秒程度、Operaだと50秒かかった。もっとも、上のものはかなり多くのシェイプを生成しているので、もっと単純なものならどのブラウザでもせいぜい2、3秒で完了する。

``` html
<script type="text/javascript" src="contextfree.js"></script>
<script type="text/javascript" src="cfdg.js"></script>
<script type="text/javascript">
    window.onload = function() {
        var src = '....'; // cfdg source
        var contextfree = new ContextFree(src, document.querySelector('canvas'));
        contextfree.render(function() {
            ... // called when rendering is done
        });
    };
</script>
```

実装にあたってはContext Freeの構文解析にJisonというパーサジェネレーターを、描画には普通にCanvas 2D APIを使っている。Context Free 2.xの文法をだいたい網羅しているが、今のところtile directive / path directiveがなく追々実装する予定。
