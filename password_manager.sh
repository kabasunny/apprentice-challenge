#!/bin/bash

echo "パスワードマネージャへようこそ！"

while true
do
	read -p "次の選択肢から入力してください(Add Password/Get Password/Exit)：" input

       if [ "$input" = "Add Password" ];
       then  
	       read -p "サービス名を入力してください:" service;
	       read -p "ユーザー名を入力してください:" user;
	       read -p "パスワード名を入力してください:" password;
	       echo "$service:$user:$password" >> pswlog.txt
	       echo "パスワードの追加は成功しました。"
   
       elif [ "$input" = "Get Password" ];
       then
	       read -p "サービス名を入力してください:" service;

       

       
       elif [ "$input" = "Exit" ];
       then
	       break
       
       else
	       echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"

       fi

done


echo "Thank you!";

