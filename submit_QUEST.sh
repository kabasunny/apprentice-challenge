#!/bin/bash

echo "パスワードマネージャへようこそ！"

read -p "サービス名を入力してください:" service;
read -p "ユーザー名を入力してください:" user;
read -p "パスワード名を入力してください:" password;

echo "$service:$user:$password" > "$service:$user:$password"


echo "Thank you!";

