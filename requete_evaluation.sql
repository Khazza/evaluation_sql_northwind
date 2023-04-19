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
SELECT CompanyName AS 'Fournisseur', COUNT(UnitsOnOrder) AS 'Nombre_produits'
FROM `suppliers` 
JOIN `products` ON products.SupplierID = suppliers.SupplierID 
WHERE Country = 'France' 
GROUP BY Fournisseur
ORDER BY UnitsInStock DESC;

--Autre possibilité :
SELECT s.CompanyName AS Fournisseurs, COUNT(p.ProductID) AS `Nbre produits`
FROM suppliers s
JOIN products p ON s.SupplierID = p.SupplierID
WHERE s.Country = 'France'
GROUP BY s.CompanyName
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


------------------------------------------------------------------------------------------------------------------------
-- 5- Liste des clients dont le montant cumulé de toutes les commandes passées est supérieur à 30000 € :

------------------------------------------------------------------------------------------------------------------------
-- 6- Liste des pays dans lesquels des produits fournis par "Exotic Liquids" ont été livrés : 

------------------------------------------------------------------------------------------------------------------------
-- 7- Chiffre d'affaires global sur les ventes de 1997 :

------------------------------------------------------------------------------------------------------------------------
-- 8- Chiffre d'affaires détaillé par mois, sur les ventes de 1997 : 

------------------------------------------------------------------------------------------------------------------------
-- 9- A quand remonte la dernière commande du client nommé "Du monde entier" ? 

------------------------------------------------------------------------------------------------------------------------
-- 10- Quel est le délai moyen de livraison en jours ? 