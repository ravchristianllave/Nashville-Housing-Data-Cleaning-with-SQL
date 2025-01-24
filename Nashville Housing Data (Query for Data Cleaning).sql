SELECT *
FROM NashvilleHousing

-----------------------------------------------------------------------------------------------
-- Standardize Date Format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ALTER COLUMN SaleDate DATE

-----------------------------------------------------------------------------------------------
-- Populate Property Address Data

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID

-----------------------------------------------------------------------------------------------
-- Breaking Out Address Into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing 

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

-- Other method

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM NashvilleHousing 

-----------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = (
			CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
					WHEN SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant
					END
					)
FROM NashvilleHousing

-----------------------------------------------------------------------------------------------
-- Remove Duplicates

-- Delete row_num > 2 (duplicates)
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) row_num
FROM NashvilleHousing
)

DELETE
FROM RowNumCTE
WHERE row_num > 1

-- Check is all row_num > 1 is deleted

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) row_num
FROM NashvilleHousing
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

-----------------------------------------------------------------------------------------------
-- Delete Unused Columns

SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

SELECT *
FROM NashvilleHousing