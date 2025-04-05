# !/bin/sh

echo "============ start $0 ============"

echo "MarkdownファイルをHTMLファイルに変換します。"
echo "コマンド例=sh md2html.sh ./input ./output ./css/markdown-preview-enhanced.css ./img"
echo "スタイルによってmarkdown-preview-enhancedか任意のスタイル(Github)かでコメントアウト部分を切り替えてください。"

echo "第1引数 Markdown 入力ディレクトリのパス（再起的に探すため最上位の検索したいディレクトリを指定） input_md_dir = $1"
echo "第2引数 HTML 出力ディレクトリのパス output_html_dir = $2"
echo "第3引数 CSS ファイルのパス css_file = $3"
echo "第4引数 Resource 画像を含むリソースディレクトリのパス resource_path = $4"

input_md_dir=$1
output_html_dir=$2
css_file=$3
resource_path=$4

echo

# パラメータのバリデーション
if [ -z "$input_md_dir" ]; then
    echo "第1引数は必須です。Markdownファイルが配置されている最上位のディレクトリを指定してください。"
    exit -1
fi

if [ -z "$output_html_dir" ]; then
    echo "第2引数は必須です。HTMLの出力ディレクトリを指定してください。"
    exit -1
fi

if [ -z "$css_file" ]; then
    echo "第3引数は必須です。CSSファイルを指定してください。"
    exit -1
fi


# ディレクトリ削除
rm -rf ${output_html_dir}

# ディレクトリ作成
mkdir ${output_html_dir}


# .md => .html 変換
for input_md_file in $(find ${input_md_dir} -type f -name '*.md'); do
    # ファイル名を取得（拡張子あり）
    filename_ext="${input_md_file##*/}"
    # echo ${filename_ext}

    # ファイル名のみを取得
	filename="${filename_ext%.*}"
    # echo ${filename}

    output_html=${output_html_dir}/${filename}.html
    # echo ${output_html}
    

    # スタイル github-markdown-light.css を使用する場合
    # pandoc -f markdown -t html5 --resource-path ${resource_path} --embed-resources --standalone -c ${css_file} ${input_md_file} > ${output_html}
    # スタイルに合わせてmarkdown-bodyを変更する
    # sed -i '' "s/<body>/<body\ class\=\"markdown-body\">/" ${output_html}

    # スタイル markdown-preview-enhanced
    pandoc -f markdown -t html5 --resource-path ${resource_path} --embed-resources --standalone -c ${css_file} ${input_md_file} > ${output_html}
    sed -i '' "s/<body>/<body\ for\=\"html-export\"><div\ class\=\"crossnote\ markdown-preview\">/" ${output_html}
    sed -i '' "s/<\/body>/<\/dev><\/body>/" ${output_html}

    echo 出力 ${output_html}
done


echo "============ end ============"