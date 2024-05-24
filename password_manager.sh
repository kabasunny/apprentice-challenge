#!/bin/bash

echo "パスワードマネージャへようこそ！"

while true
do
	read -p "次の選択肢から入力してください(Add Password/Get Password/Exit)：" input

       if [ "$input" = "Add Password" ];
       then  
	       read -p "サービス名を入力してください:" service
	       read -p "ユーザー名を入力してください:" user
	       read -p "パスワード名を入力してください:" password
	       echo "$service:$user:$password" >> pswlog.txt
	       echo "パスワードの追加は成功しました。"
   
       elif [ "$input" = "Get Password" ];
       then
	       read -p "サービス名を入力してください:" service_2
	       if grep -q "^$service_2:" pswlog.txt;
	       then
		       user_2=$(grep "^$service_2:" pswlog.txt | cut -d':' -f2)
		       password_2=$(grep "^$service_2:" pswlog.txt | cut -d':' -f3)
		       echo "ユーザー名: $user_2"
		       echo "パスワード: $password_2"

	       else
		       echo "そのサービスは登録されていません。"

	       fi
       elif [ "$input" = "Exit" ];
       then
	       break
       
       else
	       echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"

       fi

done


echo "Thank you!";

