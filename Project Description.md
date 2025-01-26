
**Project Description: Data Cleaning and Standardization of Nashville Housing Dataset**

This project involves cleaning, standardizing, and preparing the **NashvilleHousing** dataset for analysis. The following steps were executed to ensure data quality and consistency:

----------

### 1. **Standardizing Date Format**

-   Converted the `SaleDate` column to a standardized `DATE` format using `CONVERT(Date, SaleDate)`.
-   Altered the column type to `DATE` using `ALTER TABLE`.

----------

### 2. **Populating Missing Property Address Data**

-   Identified rows with null values in the `PropertyAddress` column.
-   Used a self-join approach to populate missing addresses based on matching `ParcelID` values.
-   Updated the `PropertyAddress` field for rows with missing values by inheriting data from related rows.

----------

### 3. **Breaking Out Address into Individual Components**

-   Split the `PropertyAddress` into separate columns: `PropertySplitAddress` (street address) and `PropertySplitCity` (city).
-   Applied string functions like `SUBSTRING` and `CHARINDEX` to extract address components.
-   Implemented an alternative method using `PARSENAME` to split `OwnerAddress` into `OwnerSplitAddress` (street), `OwnerSplitCity` (city), and `OwnerSplitState` (state).
-   Added new columns to store the split components.

----------

### 4. **Standardizing Boolean Values in `SoldAsVacant` Field**

-   Replaced `Y` and `N` values in the `SoldAsVacant` column with `Yes` and `No`, respectively.
-   Ensured consistency by using a `CASE` statement during updates.

----------

### 5. **Removing Duplicate Records**

-   Used a Common Table Expression (CTE) to identify duplicate rows based on `ParcelID`, `PropertyAddress`, `SalePrice`, `SaleDate`, and `LegalReference`.
-   Applied the `ROW_NUMBER()` function to assign a unique number to each duplicate group.
-   Deleted rows where `row_num > 1` to retain only the first instance of each duplicate.

----------

### 6. **Deleting Unused Columns**

-   Removed unnecessary columns (`OwnerAddress`, `TaxDistrict`, `PropertyAddress`) from the dataset to streamline the table structure.

----------

### **Result:**

The dataset was cleaned, standardized, and optimized for further analysis by resolving inconsistencies, filling missing values, breaking down composite data, and removing redundant information.
