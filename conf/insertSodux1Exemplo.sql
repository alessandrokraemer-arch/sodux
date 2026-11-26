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

insert into Fato_Saldo_da_Loja
(cnpjFK,empresa,calendarioFK,saldo,insertTimestamp,updateTimestamp)
values
('7102191000104','Gardnes',2026,45000,now(),now()),
('82571193000180','Radius',2026,70000,now(),now()),
('9127612000104','Amadeus',2026,49000,now(),now()),
('91821418000180','Citrux XA',2026,500000,now(),now());