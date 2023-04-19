-- La base Northwind
-- Ecrivez ensuite les requêtes permettant d'obtenir les résultats attendus suivants :
-- 1- Liste des clients français : 
SELECT CompanyName AS 'Société' , ContactName AS 'Contact' , ContactTitle AS 'Fonction', Phone AS 'Téléphone' 
FROM customers 
WHERE Country = 'France'; 
--Explication : 
--On sélectionne les colonnes permettant de récuperer les nom de société (CompanyName), noms des clients (ContactName), leur fonction (ContactTitle), et numéro de tel (Phone)
--de la table customers où la valeur de la colonne Country est égale à 'France'.

------------------------------------------------------------------------------------------------------------------------
-- 2- Liste des produits vendus par le fournisseur "Exotic Liquids" :
SELECT products.ProductName AS 'Produit', products.UnitPrice AS 'Prix'
FROM products
INNER JOIN suppliers ON products.SupplierID = suppliers.SupplierID
WHERE suppliers.CompanyName = 'Exotic Liquids';
--Explication :
--On sélectionne les colonnes "ProductName" et "UnitPrice" de la table "products".
--On utilise une jointure pour combiner les données des tables "products" et "suppliers" sur la colonne "SupplierID".
--On utilise un JOIN pour spécifier que les produits doivent avoir un fournisseur dont l'ID correspond à celui de la table "suppliers".
--Puis un WHERE spécifie que la compagnie du fournisseur doit être "Exotic Liquids".

------------------------------------------------------------------------------------------------------------------------
-- 3- Nombre de produits mis à disposition par les fournisseurs français (tri par nombre de produits décroissant) : 
SELECT suppliers.CompanyName AS Fournisseurs, COUNT(products.ProductID) AS `Nbre produits`
FROM suppliers
JOIN products ON suppliers.SupplierID = products.SupplierID
WHERE suppliers.Country = 'France'
GROUP BY suppliers.CompanyName
ORDER BY COUNT(products.ProductID) DESC;
--Explication :
--La requête joint les tables "suppliers" et "products" avec une clause JOIN, 
--utilise la clause WHERE pour filtrer les fournisseurs français, 
--groupe les résultats par fournisseur avec la clause GROUP BY, 
--compte le nombre de produits pour chaque fournisseur avec COUNT(), 
--et enfin trie les résultats par ordre décroissant du nombre de produits avec la clause ORDER BY.

------------------------------------------------------------------------------------------------------------------------
-- 4- Liste des clients français ayant passé plus de 10 commandes : 
SELECT customers.CompanyName AS Client, COUNT(orders.OrderID) AS `Nbre commandes`
FROM customers
JOIN orders ON customers.CustomerID = orders.CustomerID
WHERE customers.Country = 'France'
GROUP BY customers.CustomerID
HAVING COUNT(orders.OrderID) > 10;
--Explication :
--La clause "AS" est utilisée pour renommer les colonnes.
--On utilise la commande "JOIN" pour joindre les tables "customers" et "orders" en utilisant la clé étrangère "CustomerID".
--On lance la requête avec la clause "WHERE" pour filtrer les résultats et ne sélectionner que les clients français avec la valeur 'France'.
--La commande "GROUP BY" pour regrouper les résultats par client. 
--La clause "HAVING" pour filtrer les résultats et ne sélectionner que les clients ayant passé plus de 10 commandes. 
--La fonction COUNT est utilisée pour compter le nombre de commandes passées par chaque client et est utilisée pour filtrer les clients ayant passé plus de 10 commandes.

------------------------------------------------------------------------------------------------------------------------
-- 5- Liste des clients dont le montant cumulé de toutes les commandes passées est supérieur à 30000 € :
SELECT CompanyName AS Client, SUM(UnitPrice * Quantity * (1 - Discount)) AS CA, Country AS Pays
FROM customers
JOIN orders ON customers.CustomerID = orders.CustomerID
JOIN `order details` ON orders.OrderID = `order details`.OrderID
GROUP BY customers.CustomerID
HAVING CA > 30000
ORDER BY CA DESC;
--Explication :
--La clause SELECT affiche les colonnes CompanyName de la table customers pour le nom du client, 
--la somme de UnitPrice * Quantity * (1 - Discount) de la table order details pour le chiffre d'affaires (CA), 
--et Country de la table customers pour le pays.
--FROM spécifie la table à utiliser : customers
--JOIN relie les tables orders, et order details. entre elles en utilisant les clés étrangères CustomerID et OrderID.
--GROUP BY regroupe les résultats par CustomerID.
--HAVING filtre les résultats en fonction de la condition CA > 30000.
--ORDER BY trie les résultats par ordre décroissant de CA.

------------------------------------------------------------------------------------------------------------------------
-- 6- Liste des pays dans lesquels des produits fournis par "Exotic Liquids" ont été livrés : 
SELECT DISTINCT customers.Country AS Pays
FROM customers
JOIN orders ON customers.CustomerID = orders.CustomerID
JOIN `order details` od ON orders.OrderID = od.OrderID
JOIN products ON od.ProductID = products.ProductID
JOIN suppliers ON products.SupplierID = suppliers.SupplierID
WHERE suppliers.CompanyName = `Exotic Liquids`
ORDER BY Pays ASC;
--Explication :
--JOIN est utilisé pour joindre les tables entre elles en utilisant les clés étrangères CustomerID, OrderID, ProductID, SupplierID
--qui permettent de lier les informations sur les commandes, les produits, les clients et les fournisseurs.
--DISTINCT est utilisé pour ne pas afficher plusieurs fois le même pays si plusieurs commandes ont été livrées dans ce pays.
--WHERE est utilisé pour sélectionner seulement les produits fournis par "Exotic Liquids" en utilisant le nom de la compagnie dans la table "suppliers".

------------------------------------------------------------------------------------------------------------------------
-- 7- Chiffre d'affaires global sur les ventes de 1997 :
SELECT SUM(UnitPrice * Quantity) AS 'Montant Ventes 97'
FROM `order details` 
JOIN `orders` ON orders.OrderID = `order details`.`OrderID` 
WHERE YEAR(OrderDate) = 1997;
--Explication :
--SELECT affiche la somme du prix unitaire par la quantité, en tant que chiffre d'affaire sur les ventes de 1997
--FROM spéficie la table à utiliser.
--JOIN relie les tables orders et et order details par la clé étrangère OrderID.
--WHERE applique la condition de recherche sur l'année de 1997
-------- Autre possibilité 
SELECT SUM(UnitPrice * Quantity) AS `Montant Ventes 97`
FROM orders
JOIN `order details` ON orders.OrderID = `order details`.`OrderID`
WHERE YEAR(o.OrderDate) = 1997;
Explication :
--La clause FROM spécifie les tables à utiliser dans la requête, 
--ici orders et order details, jointes par la clause JOIN et liées par la clé étrangère OrderID.
--La clause SELECT spécifie les colonnes à afficher dans les résultats de la requête. 
--Ici, on calcule le sous-total de chaque produit en multipliant le prix unitaire par la quantité commandée (od.UnitPrice * od.Quantity), 
--puis on utilise la fonction d'agrégation SUM() pour faire la somme de tous les sous-totaux. On donne le nom Montant Ventes 97 à cette colonne dans les résultats.
--La clause WHERE filtre les résultats pour ne prendre en compte que les commandes passées en 1997, 
--en utilisant la fonction YEAR() pour extraire l'année de la colonne OrderDate de la table orders.

------------------------------------------------------------------------------------------------------------------------
-- 8- Chiffre d'affaires détaillé par mois, sur les ventes de 1997 : 
SELECT MONTH(OrderDate) AS mois_97, SUM(UnitPrice * Quantity) AS montant_ventes
FROM `order details` 
JOIN `orders` ON orders.OrderID = `order details`.`OrderID` 
WHERE YEAR(OrderDate) = 1997 
GROUP BY MONTH(OrderDate);
------ autre possibilité
SELECT MONTH(orders.OrderDate) AS `Mois 97`, SUM(`order details`.UnitPrice * `order details`.Quantity * (1 - `order details`.Discount)) AS `Montant Ventes`
FROM orders
JOIN `order details` ON orders.OrderID = `order details`.OrderID
JOIN products ON `order details`.ProductID = products.ProductID
WHERE YEAR(orders.OrderDate) = 1997
GROUP BY MONTH(orders.OrderDate);
--Explications:
--La fonction MONTH extrait le mois de la date de commande.
--La formule UnitPrice * Quantity * (1 - Discount) calcule le chiffre d'affaires de chaque ligne de commande.
--La clause JOIN relie les tables orders, order details, et products.
--La condition YEAR(orders.OrderDate) = 1997 filtre les commandes passées en 1997.
--La clause GROUP BY regroupe les résultats par mois de commande.

------------------------------------------------------------------------------------------------------------------------
-- 9- A quand remonte la dernière commande du client nommé "Du monde entier" ? 
SELECT MAX(OrderDate) AS Date_de_derniere_cmd
FROM `orders` 
JOIN `customers` ON customers.CustomerID = orders.CustomerID 
WHERE CompanyName = 'Du monde entier';
------Autre
SELECT MAX(OrderDate) AS `Date de dernière commande`
FROM orders
WHERE CustomerID = 'Du monde entier';
--Cette requête sélectionne la date de la dernière commande passée par le client nommé "Du monde entier" en utilisant 
--la fonction MAX pour trouver la date la plus récente.

------------------------------------------------------------------------------------------------------------------------
-- 10- Quel est le délai moyen de livraison en jours ? 
SELECT AVG(DATEDIFF(ShippedDate, OrderDate )) AS Délais_moyen_de_livraison
FROM `orders`;
-----Autre
SELECT AVG(DATEDIFF(ShippedDate, OrderDate)) AS `Delai moyen de livraison en jours` 
FROM orders WHERE ShippedDate IS NOT NULL;
--Explications :
--SELECT AVG() permet de calculer la moyenne des valeurs.
--DATEDIFF(ShippedDate, OrderDate) permet de calculer la différence entre la date d'expédition et la date de commande en jours.
--FROM orders spécifie la table à utiliser.
--WHERE ShippedDate IS NOT NULL permet de filtrer les commandes qui ont été expédiées.