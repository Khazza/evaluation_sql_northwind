---- La base Northwind
-- Ecrivez ensuite les requêtes permettant d'obtenir les résultats attendus suivants :
-- 1- Liste des clients français : 
SELECT CompanyName AS 'Société' , ContactName AS 'Contact' , ContactTitle AS 'Fonction', Phone AS 'Téléphone' 
FROM customers 
WHERE Country = 'France'; 
--Explication: 
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
ORDER BY COUNT(p.ProductID) DESC;
--Explication :
--La requête joint les tables "suppliers" et "products" avec une clause JOIN, 
--utilise la clause WHERE pour filtrer les fournisseurs français, 
--groupe les résultats par fournisseur avec la clause GROUP BY, 
--compte le nombre de produits pour chaque fournisseur avec COUNT(), 
--et enfin trie les résultats par ordre décroissant du nombre de produits avec la clause ORDER BY.

------------------------------------------------------------------------------------------------------------------------
-- 4- Liste des clients français ayant passé plus de 10 commandes : 
SELECT CompanyName AS Client, COUNT(OrderId) as Nbre_commandes
FROM `customers` 
JOIN `orders` 
ON orders.CustomerID = customers.CustomerID 
WHERE Country = 'France' 
GROUP BY Client 
HAVING Nbre_commandes > 10;
---------
SELECT customers.CompanyName AS Client, COUNT(orders.OrderID) AS `Nbre commandes`
FROM customers
JOIN orders ON customers.CustomerID = orders.CustomerID
WHERE customers.Country = 'France'
GROUP BY customers.CustomerID
HAVING COUNT(orders.OrderID) > 10;
--Explication de la requête :
--La première ligne de la requête sélectionne la colonne "CompanyName" de la table "customers" et la renomme en "Client", 
--ainsi que la colonne "OrderID" de la table "orders" et la renomme en "Nbre commandes". La clause "AS" est utilisée pour renommer les colonnes.
--La deuxième ligne de la requête utilise la commande "JOIN" pour joindre les tables "customers" et "orders" en utilisant la clé étrangère "CustomerID".
--La troisième ligne de la requête utilise la clause "WHERE" pour filtrer les résultats et ne sélectionner que les clients français. 
--La valeur 'France' est utilisée pour sélectionner les clients français.
--La quatrième ligne de la requête utilise la commande "GROUP BY" pour regrouper les résultats par client. 
--La fonction COUNT est utilisée pour compter le nombre de commandes passées par chaque client.
--La cinquième ligne de la requête utilise la clause "HAVING" pour filtrer les résultats et ne sélectionner que les clients ayant passé plus de 10 commandes. 
--La fonction COUNT est utilisée pour filtrer les clients ayant passé plus de 10 commandes.
------------------------------------------------------------------------------------------------------------------------
-- 5- Liste des clients dont le montant cumulé de toutes les commandes passées est supérieur à 30000 € :
SELECT SUM(UnitPrice * Quantity) AS 'CA' , CompanyName as 'client' 
FROM `customers` 
INNER JOIN `orders` ON orders.CustomerID = customers.CustomerID
JOIN `order_details` ON `order_details`.orderID = orders.OrderID 
GROUP BY Client HAVING CA > 30000;
----
SELECT customers.CompanyName AS Client, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS CA, customers.Country AS Pays
FROM customers
JOIN orders ON customers.CustomerID = orders.CustomerID
JOIN order_details od ON orders.OrderID = od.OrderID
GROUP BY customers.CustomerID
HAVING CA > 30000
ORDER BY CA DESC;
--Explications :
--La clause SELECT sélectionne les colonnes CompanyName de la table customers pour le nom du client, 
--la somme de UnitPrice * Quantity * (1 - Discount) de la table order details pour le chiffre d'affaires (CA), et Country de la table customers pour le pays.
--La clause FROM spécifie les tables à utiliser : customers, orders, et order details.
--La clause JOIN relie les tables entre elles en utilisant les clés étrangères CustomerID et OrderID.
--La clause GROUP BY regroupe les résultats par CustomerID.
--La clause HAVING filtre les résultats en fonction de la condition CA > 30000.
--La clause ORDER BY trie les résultats par ordre décroissant de CA.

------------------------------------------------------------------------------------------------------------------------
-- 6- Liste des pays dans lesquels des produits fournis par "Exotic Liquids" ont été livrés : 
SELECT ShipCountry AS pays
FROM `orders` 
JOIN `order details`
ON `order details`.`OrderID` = orders.OrderID 
JOIN `products` 
ON products.ProductID = `order details`.`ProductID`
JOIN `suppliers` 
ON suppliers.SupplierID = products.SupplierID
WHERE suppliers.CompanyName = 'Exotic Liquids' 
GROUP BY pays;
----
SELECT DISTINCT c.Country AS Pays
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
JOIN products p ON od.ProductID = p.ProductID
JOIN suppliers s ON p.SupplierID = s.SupplierID
WHERE s.CompanyName = 'Exotic Liquids';
--Explication :
--La clause INNER JOIN est utilisée pour joindre les tables entre elles en utilisant les clés étrangères (CustomerID, OrderID, ProductID, SupplierID) 
--qui permettent de lier les informations sur les commandes, les produits, les clients et les fournisseurs.
--La clause DISTINCT est utilisée pour ne pas afficher plusieurs fois le même pays si plusieurs commandes ont été livrées dans ce pays.
--La condition WHERE est utilisée pour sélectionner seulement les produits fournis par "Exotic Liquids" en utilisant le nom de la compagnie dans la table "suppliers".


------------------------------------------------------------------------------------------------------------------------
-- 7- Chiffre d'affaires global sur les ventes de 1997 :

------------------------------------------------------------------------------------------------------------------------
-- 8- Chiffre d'affaires détaillé par mois, sur les ventes de 1997 : 

------------------------------------------------------------------------------------------------------------------------
-- 9- A quand remonte la dernière commande du client nommé "Du monde entier" ? 

------------------------------------------------------------------------------------------------------------------------
-- 10- Quel est le délai moyen de livraison en jours ? 