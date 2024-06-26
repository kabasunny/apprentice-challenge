#!/bin/bash

# シグナルをトラップして、ファイルの削除処理を呼び出す
trap "del_file" 1 2 6 15 # 

# 暗号化と復号時のバッチ処理に必要なパスフレーズ
pass='apprentice-challenge'

#暗号ファイル有の場合、復号する処理
function d_file() {
	if [ -f 'pswlog.txt.gpg' ];
	then
		# 復号
		echo $pass | gpg --quiet --batch --yes --passphrase-fd 0\
			--output 'pswlog.txt' --decrypt 'pswlog.txt.gpg'\
			# gpg: AES256 encrypted data が表示されていた
                          # > /dev/null 2>&1では消えない 標準入出力ではない様だ
                          #  --quiet　で抑制できる
		  # --batch : 対話的なプロンプト表示を抑制する
		  # --yes : ユーザーの介入なしにyesを実行
		  # --passhrase-fd 0 : 標準入力(echo $pass |)から読み取る
	fi
}

#暗号化する処理
function e_file() {
	# 暗号化
	echo $pass | gpg --quiet --batch --yes --passphrase-fd 0 \
		       -c 'pswlog.txt' 
			       # gpg: encrypted with 1 passphrase が表示されていた
	rm 'pswlog.txt'
}

# 正常終了しない場合の平文ファイルの削除処理
function del_file(){
	if [ -f 'pswlog.txt' ];
	then 
		rm pswlog.txt
	fi
	echo -e "\n【シグナルによる終了】\n"
	exit 1	
}

# メインの処理はここから
echo 'パスワードマネージャへようこそ！'

while true
do

	echo '次の選択肢の番号を入力し、enterキーを押してください。'
	read -p ' 1 :Add Password  /  2 :Get Password  /  3 :Exit   :' input

       if [ "$input" = '1' -o "$input" = '１' ];
       then
	       echo '1:Add Passwordを選択しました。'
	       read -p 'サービス名を入力し、enterキーを押してください:' service
	       
	       # 復号
	       d_file
	       
	       if grep -q "^$service:" pswlog.txt 2>/dev/null;
	       # 重複登録を拒否する処理。初回のエラーを非表示
	       then
		       echo "入力されたサービス: $service は登録済みです。"
		       echo -e "パスワードを取得するには 2 を選択してください。\n"
		       continue
	       fi
	       read -p 'ユーザー名を入力し、enterキーを押してください:' user
	       read -p 'パスワードを入力し、enterキーを押してください:' password
	       echo "$service:$user:$password" >> pswlog.txt
	       echo 'パスワードの追加は成功しました。'
	       # 変数展開、コマンド置換や特殊文字を解釈させたい場合は、ダブルクォートを使用
	       # 文字列を原文通りとして扱いたい場合は、シングルクォートを使用

	       # 暗号化
	       e_file

       elif [ "$input" = '2' -o "$input" = '２' ];
       then
	       echo '2:Get Passwordを選択しました。'  
	       read -p 'サービス名を入力し、enterキーを押してください:' service_2
	       
               # 復号
               d_file

	       if grep -q "^$service_2:" pswlog.txt 2>/dev/null; # -qで標準出力を抑制し、初回のエラーを非表示
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
		       echo "サービス名: $service_2"
		       echo "ユーザー名: $user_2"
		       echo "パスワード: $password_2"
	       else
		       echo 'そのサービスは登録されていません。'
	       fi
	       
	       # 暗号化
	       e_file

       elif [ "$input" = '3' -o "$input" = '３' ];
       then
	       echo '3:Exitを選択しました。'
	       break
       
       # 管理者用の処理として、現在のリスト一覧を表示
       elif [ "$input" = 'admin' ];
       then
	       echo '現在のリスト一覧 (管理者用の処理)'
	       if [ ! -f  'pswlog.txt.gpg' ];
	       then
		       echo -e "現在、リストが存在しません。\n"
		       exit 0
	       fi
	       d_file
	       echo 'サービス名:ユーザー名:パスワード'
	       cat pswlog.txt
	       rm pswlog.txt
	       echo ''
	       exit 0
       else
	       echo '入力が間違えています。1 / 2 / 3 から選択してください。'
       fi
       echo ''
      
done
echo -e "Thank you!\n";

