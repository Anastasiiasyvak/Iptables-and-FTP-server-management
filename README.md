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

### b. Скрипт повинен додати правило до iptables для заборони ping через icmp з будь-якого хоста. 

- в контейнері вводимо команду `nano setup_node.sh` для редагування файлу.

  ![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/4551a8f7-908b-447c-8bf3-70712a570298)

 таким чином, ми заборонили відповідь на пінги з будь-якого хоста:
1 `-p icmp` вказуємо на використання протоколу ICMP для специфікації типу пакетів
2 `--icmp-type echo-request` пакет, який генерується при виконанні команди пінгування.
3 `j DROP` пакети, в нашому випадку, пінги, будуть заблоковані.

- виконую команду `./setup_node.sh`
- вводжу команду `ifconfig` для того, щоб дізнатися ip-адресу нашого сервера

![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/08c2105c-036e-4aca-b384-b3a31d6ada20)

  адреса `10.120.55.242`
  
- вводимо в терміналі `ping 10.120.55.242`

![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/d770e4a8-2e4d-4945-b234-7c8e508cb4e8)

- з попередньої фотографії, ми можемо побачити, що в першому випадку пінгування, ми отримували відповідь,так як ми не мали правила блокування пінгу, другий раз, ми бачимо, що не відбувається контакт, так як ми вже ввели це блокування.
  
- ми можемо нижче переглянути правила iptables, до додавання правила

  ![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/f91757dc-b664-4c47-9792-bd1845a7539f)

- та після додавання правила

  ![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/ddd07887-b64d-44ba-a912-d2b60b80de5d)

*- Chain INPUT (policy ACCEPT):*
перший ланцюг у системі правил iptables, який обробляє всі вхідні пакети до системи.
policy ACCEPT означає, що за замовчуванням (політика) всі вхідні пакети дозволені (accept). Це означає, що якщо пакет не відповідає жодному правилу, він буде прийнятий.

### c. Будь-який доступ до FTP-сервера має бути заборонено за допомогою iptables. Виняток слід надавати лише для списку IP-адрес, що передаються на вхід скрипту з переліком, розділеним комами, наприклад:./setup_node.sh 192.168.0.5,10.10.1.2,10.10.2.1

- в контейнері вводимо команду `nano setup_node.sh` для редагування файлу.

![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/0dceda3f-c3bd-4be6-803a-65b911240245)

- `IFS=','` ми встановлюємо роздільник, аргументу який введе користувач і збережемо це в масиві `ip-addresses` з допомогою -a
- 21 це є стандартний порт для з'єднань з FTP сервером.
- ми встановили ACCEPT для всіх айпі адрес в масиві
- для всіх інших адрес DROP
  
![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/1479cf1a-aa6c-4310-863b-50d600d280af)

### d. Додайте користувача ftp_user з паролем MyFTPPass!

![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/00b11934-43fe-44ee-b38a-8c31f118a9f8)

- додаємо користувача
- вводимо нам потрібний пароль, MyFTPPass!

![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/f1521428-54cf-423d-95e8-411efa9daffd)

- переконуємось, що користувач буд доданий, ми бачимо інформацію про нового користувача
- входимо в систему, за допомогою користувача

  ### e. Додайте 2 файли 1.txt і 2.txt з рядком Hello World! у кожному, які мають бути доступні по ftp в /home/ftp_user.

![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/1a88c15c-7ee3-4ff2-9d65-97a358319cc8)

- `su - ftp_user`
- `cd ~` переходимо в домашній каталог ftp_user (хоча ми вже тут і знаходились)
- `echo "Hello World!" > 1.txt` `echo "Hello World!" > 2.txt` створюємо файли 1.txt та 2.txt і записуємо туди контент hello world
- `ls` перевіряємо чи ми успішно створили файлики
- `exit` вийшли з облікового запису ftp_user

  ### f. Скрипт має бути тихим, тобто не вимагати від користувача жодних дій, окрім введення sudo пароль.

  ![image](https://github.com/Anastasiiasyvak/Iptables-and-FTP-server-management/assets/119412566/58c86fb5-169b-43b6-b451- 
  9ba6392d52b3)
  
  - додали у наш код строку `exec > /dev/null 2>&1` для того, щоб будь-який наш вивід (stdout) або помилки (stderr) мого скрипту надсилались до /dev/null, тобто видалялись. Це робить мій скрипт тихим і вивід та помилки не будуть відображатись в терміналі.  

