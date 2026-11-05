use enterprise;
insert into autenticacaoMais
(
tokenVigente,
usuario,
senha,
sessaoUltima,
dataHoraUltimaAutorizacao
) 
values
(
hex(rand()*0xFFFFFFFF),
'administrador',
MD5('mais!'),
'386971A9FEBC6D563BAEF427DA4EF250',
now());

