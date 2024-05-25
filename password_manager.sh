#!/bin/bash

echo 'パスワードマネージャへようこそ！'

while true
do
	read -p '次の選択肢の番号を入力してください( 1:Add Password / 2:Get Password / 3:Exit )：' input

       if [ "$input" = '1' ];
       then
	       echo '1:Add Passwordを選択しました。'
	       read -p 'サービス名を入力してください:' service
	       read -p 'ユーザー名を入力してください:' user
	       read -p 'パスワード名を入力してください:' password
	       echo "$service:$user:$password" >> pswlog.txt
	       echo 'パスワードの追加は成功しました。'
	       # 変数展開、コマンド置換や特殊文字を解釈させたい場合は、ダブルクォートを使用
	       # 文字列を原文通りとして扱いたい場合は、シングルクォートを使用   
       elif [ "$input" = '2' ];
       then
	       echo '2:Get Passwordを選択しました。'
	       read -p 'サービス名を入力してください:' service_2
	       if grep -q "^$service_2:" pswlog.txt; # -qで、標準出力を抑制
	       # if grep "^$service_2:" pswlog.txt > /dev/null; # > /dev/nullで、標準出力を抑制
	       # if a=$(grep "^$service_2:" pswlog.txt); # a=()で、標準出力を抑制
	         # 上記のif command文は、条件の判定ではなく、シェルコマンドの終了ステータスによる
	         #   終了ステータスは、戻り値とは別の情報
	         #   終了ステータスが成功:0 のとき、直後のthenの処理になる
	         #   シェルコマンドは実行後、常に終了ステータスを返す
	         #   この点を考慮して、エラーハンドリングを行う
               then
		       user_2=$(grep "^$service_2:" pswlog.txt | cut -d':' -f2) 
		       # grep 第1引数 第2引数　は、
		       #   第1引数(文字列)を含む全ての行を第2引数(ファイル)から抽出
		       # ^$変数名:　は、
		       #   各文の先頭から:までが変数の内容と一致する
		       # cut -d引数(文字列) -f番号　は、
		       #   引数は、その分を分割する文字列で、番号は分割したとき何番目か表す
		       # | (パイプ)で1つ目のコマンドの結果を2つ目のコマンドに入力
		       password_2=$(grep "^$service_2:" pswlog.txt | cut -d':' -f3)
		       echo "ユーザー名: $user_2"
		       echo "パスワード: $password_2"
	       else
		       echo 'そのサービスは登録されていません。'
	       fi
       elif [ "$input" = '3' ];
       then
	       echo '3:Exitを選択しました。'
	       break
       else
	       echo '入力が間違えています。Add Password/Get Password/Exit から入力してください。'
       fi

done

echo "Thank you!";

