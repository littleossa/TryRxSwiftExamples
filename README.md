# TryRxSwiftExamples
RxSwift公式ドキュメント内Examples "<b>ReactiveValues</b>"の章を勉強しつつ作成した学習用サンプル

ReactiveValuesの章を自分なりに派生させ、UIと関連づけたサンプルアプリです。
 
# DEMO

![reactiveValuesDemo](https://user-images.githubusercontent.com/67716751/112094218-3732aa80-8bde-11eb-81dc-83fb920697cd.GIF)

`a + B`の合計値が正の数であれば、結果の文字下に合計値が表示され、負の数であれば非表示になります。
＋マーク時には計算式は足し算となります。＋マークをタップすると、-に切り替わり計算式も引き算に変更されます。

# Features

 `ReactiveValuesViewController`では、公式Examples "ReactiveValues"に日本語訳コメントを付けたコードを載せております。
 `ReactiveValuesWithUIViewController`では、ReactiveValuesの章を自分なりに派生させ、UIと関連づけたサンプルを作成し、そのコードを載せております。
 
# Requirement
 
* RxSwift
* RxCocoa
 
# Installation
  
```
pod 'RxSwift', '~> 4.0'
pod 'RxCocoa', '~> 4.0'
```
 
# Note
 
初期設定では、`ReactiveValuesWithUI.storyboard`に遷移するようになっております。
公式Examples "ReactiveValues"の日本語訳コメントの挙動がみたい場合は遷移先を`ReactiveValues.storyboard`に変更して下さい。

# Reference

[RxSwift/Documentation/Examples](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Examples.md#automatic-input-validation)
