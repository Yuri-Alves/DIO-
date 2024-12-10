
create database ecommerce;
use ecommerce;



create table clients(
	idClient int auto_increment primary key, 
    Fname varchar(10) not null,
    Minit char(3),
	Lname varchar(20),
    Address varchar(90),
    Nasc_Data date,
    CPF char(11) not null,
    constraint unique_cpf_client unique (CPF)
);

alter table clients auto_increment=1;

create table product(
	idProduct int auto_increment primary key, 
    Pname varchar(50) not null,
    Category Enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
	Classification_kids boolean default false,
    Avaliação float default 0,
    Size varchar(10)
);

alter table product auto_increment=1;

create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false, 
    constraint fk_order_client foreign key (idOrderClient) references clients(idClient) 
		on update cascade
);

alter table orders auto_increment=1;

create table payments(
	idPaymentClient int,
    idPayment int,
    typePayment enum('Cartão','Dois cartões'),
    limitAvailable float,
    primary key (idPaymentClient, idPayment),
    constraint fk_payment_order foreign key (idPayment) references orders(idOrder),
    constraint fk_payment_client foreign key (idPaymentClient) references clients(idClient) 
);

create table productStorage(
	idPordStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

alter table productStorage auto_increment=1;


create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255),
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

alter table supplier auto_increment=1;

create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    contact char(11) not null,
    location varchar(255),
    constraint unique_cnpj_seller unique(CNPJ),
    constraint unique_cpf_seller unique(CPF)
);

alter table seller auto_increment=1;

create table product_seller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_POproduct foreign key (idPOproduct) references product(idProduct),
    constraint fk_POorder foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_Lproduct foreign key (idLproduct) references product(idProduct),
    constraint fk_Lsotrage foreign key (idLstorage) references productStorage(idPordStorage)
);

create table productSupplier(
	idPsupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

create table delivery(
	idDeliveryOrder int,
    idDeliveryStatus enum('A caminho','Entregue','Em separação no estoque','Aguardando reposição no estoque') default 'Em separação no estoque',
    DeliveryCode varchar(15),
    primary key(idDeliveryOrder),
    constraint fk_delivery_order foreign key (idDeliveryOrder) references orders(idOrder)
);


-- Quantos pedidos já foram entregues?--
select count(*) as delivered_orders
from delivery
where idDeliveryStatus = 'Entregue';


--  Quantos pedidos foram feitos por cada cliente?
select c.idClient, concat(c.Fname, ' ', c.Lname) as nome_cliente, count(o.idOrder) as total_pedidos
from clients c
join orders o on c.idClient = o.idOrderClient
group by c.idClient
order by total_pedidos desc;


-- Quais fornecedores possuem maior número de produtos?--

select s.SocialName, sum(ps.quantity) as total_products from productSupplier ps
join supplier s on ps.idPsupplier = s.idSupplier
group by s.SocialName
order by total_products desc;


-- quantidade de produtos especificos vendidas--
select 
    p.Category as categoria,
    p.Pname as produto,
    s.SocialName as fornecedor,
    sum(po.poQuantity) as quantidade_vendida
from productOrder po
join product p on po.idPOproduct = p.idProduct
join productSupplier ps on ps.idPsProduct = p.idProduct
join supplier s on ps.idPsupplier = s.idSupplier
group by p.Category, p.Pname, s.SocialName
order by p.Category, quantidade_vendida desc;

-- Algum vendedor também é fornecedor?
select s.idSeller, s.SocialName as vendedor, count(distinct ps.idPseller) as total_fornecimentos
from seller s
left join product_seller ps on s.idSeller = ps.idPseller
group by s.idSeller
having total_fornecimentos > 0;

-- Relação de produtos fornecedores e estoques

select p.Pname as produto, s.SocialName as fornecedor, ps.quantity as estoque
from productSupplier ps
join product p on ps.idPsProduct = p.idProduct
join supplier s on ps.idPsupplier = s.idSupplier;

