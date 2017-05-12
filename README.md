# Unpivot filter plugin for Embulk

[Embulk](https://github.com/embulk/embulk/) filter plugin to nomalize fields.

「横持ち」のテーブル構造から「縦持ち」のテーブルに変換するembulkフィルタ。

こちらにも書いてます。
http://qiita.com/takemi-ohama/items/0c01b7b41f3cf08e968f

## Overview

* **Plugin type**: filter

設備が1列に並んでいる不動産物件データを縦持ちに変換する例

* 変換元物件データ

|物件ID|家賃|ペット可|駐車場付き|バス・トイレ別|エアコン|
|---|---|---|---|---|---|
|1|8.5|0|0|1|1|
|2|5.5|0|0|0|0|
|3|10.0|1|0|1|1|
|4|15.5|0|1|1|1|

* 設備コード表

|設備ID|設備|
|---|---|
|1|ペット可|
|2|駐車場付き|
|3|バス・トイレ別|
|4|エアコン|

*↓*

* 変換後データ

|物件ID|設備ID|
|---|---|
|1|3|
|1|4|
|3|1|
|3|3|
|3|4|
|4|2|
|4|3|
|4|4|

## Configuration

- **outer_key**: normalization record id field name(string, required)
- **inner_key**: master id field name (string, required)   
- **columns**: master key/value set (array, default: [])  
- **additional**: additional field (array, default: [])

## Example

```
filters:
  - type: column
    add_columns:
      - {name: 設備ID, type: long, default: 0}
      - {name: created_at, type: timestamp, src: '物件情報入力日'}
      - {name: updated_at, type: timestamp, src: '物件情報更新日'}
  - type: unpivot
    outer_key: 物件ID
    inner_key: 設備ID
    additional: [created_at, updated_at]
    columns:
      - {name: 'ペット可', id: 1}
      - {name: '駐車場付き', id: 2}
      - {name: 'バス・トイレ別', id: 3}
      - {name: 'エアコン', id: 4}
```

## Build

```
$ rake
```
