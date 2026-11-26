create user if not exists 'saas'@'localhost' identified by 'saas';
create database if not exists enterprise;
grant all privileges on enterprise .* to 'saas'@'localhost';
flush privileges;
use enterprise;
create table if not exists autenticacaoMais (tokenVigente varchar(100), usuario varchar(50), senha varchar(100), sessaoUltima varchar(100), dataHoraUltimaAutorizacao datetime, primary key (tokenVigente,usuario));
create table if not exists Fato_Saldo_da_Loja (cnpjFK varchar(14), empresa varchar(50), calendarioFK int, saldo float, insertTimestamp datetime, updateTimestamp datetime); 
exit;
