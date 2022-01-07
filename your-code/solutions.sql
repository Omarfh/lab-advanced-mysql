-- Challenge 1

-- sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100

SELECT ti.title_id, au.au_id, IFNULL((ti.price * sa.qty * ti.royalty / 100 * ta.royaltyper / 100),0) AS 'royalties'
FROM publications.titles ti
LEFT JOIN publications.sales sa ON ti.title_id = sa.title_id
LEFT JOIN publications.titleauthor ta ON ti.title_id = ta.title_id
INNER JOIN publications.authors au ON ta.au_id = au.au_id
GROUP BY ti.title_id;

-- Aggregate the total royalties for each title for each author

SELECT ti.title_id, au.au_id,
IFNULL((ti.advance * ta.royaltyper/100) + (ti.price * spt.sales_per_title * 
ti.royalty / 100 * ta.royaltyper / 100), 0) as 'profit'
FROM (
	SELECT title_id, SUM(qty) as 'sales_per_title'
	FROM publications.sales
	GROUP BY title_id
	) AS spt
LEFT JOIN publications.titleauthor ta ON spt.title_id = ta.title_id
LEFT JOIN publications.titles ti ON ta.title_id = ti.title_id
LEFT JOIN publications.authors au ON ta.au_id = au.au_id
ORDER BY profit DESC
LIMIT 3;

-- Challenge 2:

CREATE TEMPORARY TABLE publications.sales_per_title
SELECT title_id, SUM(qty) as 'sales_per_title'
FROM publications.sales
GROUP BY title_id;

SELECT au.au_id, au_lname, au_fname, 
IFNULL((ti.advance * ta.royaltyper/100) + (ti.price * spt.sales_per_title * 
ti.royalty / 100 * ta.royaltyper / 100), 0) as 'profit'
FROM publications.authors au
LEFT JOIN publications.titleauthor ta ON au.au_id = ta.au_id
LEFT JOIN publications.titles ti ON ta.title_id = ti.title_id
LEFT JOIN publications.sales_per_title spt ON ta.title_id = spt.title_id
ORDER BY profit DESC
LIMIT 3;

-- Challenge 3

CREATE TABLE most_profiting_authors
SELECT au.au_id,
IFNULL((ti.advance * ta.royaltyper/100) + (ti.price * spt.sales_per_title * 
ti.royalty / 100 * ta.royaltyper / 100), 0) as 'profits'
FROM (
	SELECT title_id, SUM(qty) as 'sales_per_title'
	FROM publications.sales
	GROUP BY title_id
	) AS spt
LEFT JOIN publications.titleauthor ta ON spt.title_id = ta.title_id
LEFT JOIN publications.titles ti ON ta.title_id = ti.title_id
LEFT JOIN publications.authors au ON ta.au_id = au.au_id
ORDER BY profits DESC
