create user if not exists 'saas'@'localhost' identified by 'saas';
create database if not exists enterprise;
grant all privileges on enterprise .* to 'saas'@'localhost';
flush privileges;
use enterprise;
create table if not exists autenticacaoMais (tokenVigente varchar(100), usuario varchar(50), senha varchar(100), sessaoUltima varchar(100), dataHoraUltimaAutorizacao datetime, primary key (tokenVigente,usuario));
exit;
