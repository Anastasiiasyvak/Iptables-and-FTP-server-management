# Iptables-and-FTP-server-management

## 0. Підготуйте чистий контейнер Multipass на основі образу Ubuntu 22.04. Процес встановлення має бути частиною документа README.md.

- Першим моїм кроком було створення цього приватного репозиторію, з README.md файлом в ньому.
- Тепер ми відкрили термінал, і для створення контейнера ввели наступну команду:

`multipass launch 22.04 --name=second-homework`
Мій контейнер має назву `second-homework`. Якщо назва контейнера складається з більше ніж 1 слова, то воно повинно писатись через `-` а не через `_`, бо це видасть помилку.

![Статус контейнера](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/93b6f467-00c4-4f2a-84b4-d474f5566cb3)

![Відкриття контейнера](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/c55b0875-5e64-43e7-953c-e1d76bbf7bf4)

- Як бачимо, мій контейнер у стані `running`.
- Тепер відкриваємо контейнер і можемо працювати у ньому.

![Відкриття контейнера](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/c10cedc1-e3cf-474b-8e1b-3dcee5ffe729)

## 1. Створіть скрипт setup_node.sh

- я почала зі створення папки, тож створимо в контейнері папку `mkdir second_homework`
- заходимо в неї `cd second homework`
- і тут створюємо потрібний файл `touch setup_node.sh`
- надаємо можливість execute out file `chmod +x setup_node.sh`
  
![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/577e97a6-512b-444c-a0d0-dd463db8e017)

### a. Setup ifconfig, nmap tools and FTP server vsftpd.

тож ми знаходимось в нашому контейнері, і ми вводимо команди
- `sudo apt update` для оновлення всіх пакетів на найновішу версію
- `sudo apt install net-tools` (для встановлення ifconfig інтструментів) 
- `sudo apt install nmap` (для сканування мережі і виявлення хостів) 
- `sudo apt install vsftpd` ( (Very Secure FTP Daemon) швидкий і легкий у використанні FTP-сервер)

*FTP-сервер* (File Transfer Protocol Server) 
це програмне забезпечення, яке дозволяє здійснювати передачу файлів між комп'ютерами через мережу за допомогою протоколу FTP. Він використовується для надання доступу до файлів на сервері і може бути використаний як для публічного, так і для приватного обміну файлами.


