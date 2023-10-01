SELECT*
FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]

SELECT SaledateConverted, CONVERT(Date,Saledate)
FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]

UPDATE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE [NashvilleHousing]
Add SaleDateConverted Date;

UPDATE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT *
FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
--WHERE PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] a
JOIN [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] a
JOIN [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

SELECT PropertyAddress
FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
--WHERE PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress)) as Address

FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Add PropertySplitAddress Nvarchar(255);

UPDATE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Add PropertySplitcity  NVarchar(255);

UPDATE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET PropertySplitcity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress))

SELECT*
FROM  [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]


SELECT OwnerAddress
FROM  [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', ','), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', ','), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', ','), 1)
FROM  [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Add OwnerSplitAddress Nvarchar(255);

UPDATE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', ','), 3)


ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Add OwnerSplitcity Nvarchar(255);

UPDATE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET OwnerSplitcity = PARSENAME(REPLACE(OwnerAddress, ',', ','), 2)

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
Add OwnerSplitstate Nvarchar(255);

UPDATE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
SET OwnerSplitstate = PARSENAME(REPLACE(OwnerAddress, ',', ','), 1)

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]

UPDATE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] 
SET  SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END

WITH RowNumCTE AS(
SELECT *,
 ROW_NUMBER() OVER (
 PARTITION BY ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY
			  UniqueID
			  ) row_num

FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] 
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

SELECT *
FROM [PORTFOLIO PROJECT].[dbo].[NashvilleHousing] 

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE [PORTFOLIO PROJECT].[dbo].[NashvilleHousing]
DROP COLUMN SaleDate
