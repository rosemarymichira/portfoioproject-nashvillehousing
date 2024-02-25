--cleaning data in sql queries.

select *
from [PORTFOLIO PROJECT]..nashvillehousing


select SaleDate, convert(date, SaleDate)
from [PORTFOLIO PROJECT]..nashvillehousing



alter table [PORTFOLIO PROJECT]..nashvillehousing
add saledateconverted date;


update [PORTFOLIO PROJECT]..nashvillehousing
set saledateconverted = convert(date, SaleDate)

select saledateconverted  , convert(date, SaleDate)
from [PORTFOLIO PROJECT]..nashvillehousing



select*
from [PORTFOLIO PROJECT]..nashvillehousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [PORTFOLIO PROJECT]..nashvillehousing a
join [PORTFOLIO PROJECT]..nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from [PORTFOLIO PROJECT]..nashvillehousing a
join [PORTFOLIO PROJECT]..nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


select PropertyAddress
from [PORTFOLIO PROJECT]..nashvillehousing

select 
substring(PropertyAddress, 1, charindex(',',PropertyAddress)-1) as Address
, substring(PropertyAddress, charindex(',',PropertyAddress) +1 , len(PropertyAddress)) as Address

from [PORTFOLIO PROJECT]..nashvillehousing

alter table [PORTFOLIO PROJECT]..nashvillehousing
add propertysplitaddresss nvarchar(255);

update [PORTFOLIO PROJECT]..nashvillehousing
set propertysplitaddresss = substring(PropertyAddress, 1, charindex(',',PropertyAddress)-1)

alter table [PORTFOLIO PROJECT]..nashvillehousing
add propertysplitcity nvarchar(255);

update [PORTFOLIO PROJECT]..nashvillehousing
set propertysplitcity =substring(PropertyAddress, charindex(',',PropertyAddress) +1 , len(PropertyAddress))


select *
from [PORTFOLIO PROJECT]..nashvillehousing

alter table [PORTFOLIO PROJECT]..nashvillehousing
drop column saledate, PropertyAddress, OwnerAddress, taxDistrict

select OwnerAddress
from [PORTFOLIO PROJECT]..nashvillehousing

select 
parsename(replace(OwnerAddress, ',','.'),3)
,parsename(replace(OwnerAddress, ',','.'),2)
,parsename(replace(OwnerAddress, ',','.'),1)
from [PORTFOLIO PROJECT]..nashvillehousing

alter table [PORTFOLIO PROJECT]..nashvillehousing
add ownersplitaddresss nvarchar(255);

update [PORTFOLIO PROJECT]..nashvillehousing
set ownersplitaddresss = parsename(replace(OwnerAddress, ',','.'),3)

alter table [PORTFOLIO PROJECT]..nashvillehousing
add ownersplitcity nvarchar(255);

update [PORTFOLIO PROJECT]..nashvillehousing
set ownersplitcity =parsename(replace(OwnerAddress, ',','.'),2)

alter table [PORTFOLIO PROJECT]..nashvillehousing
add ownersplitstate nvarchar(255);

update [PORTFOLIO PROJECT]..nashvillehousing
set ownersplitstate =parsename(replace(OwnerAddress, ',','.'),1)

select *
from [PORTFOLIO PROJECT]..nashvillehousing


select distinct(SoldAsVacant), count(SoldAsVacant)
from [PORTFOLIO PROJECT]..nashvillehousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'YES'
         WHEN SoldAsVacant = 'N' then 'NO'
		 else SoldAsVacant
		 end
from [PORTFOLIO PROJECT]..nashvillehousing

update [PORTFOLIO PROJECT]..nashvillehousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'YES'
         WHEN SoldAsVacant = 'N' then 'NO'
		 else SoldAsVacant
		 end



with rownumcte as(
select *, 
ROW_NUMBER() over(
partition by parcelID,
             propertyAddress,
			 salePrice,
			 saleDate,
			 LegalReference
			 order by 
			 UniqueId
			 ) row_num
		
from [PORTFOLIO PROJECT]..nashvillehousing
)
delete
from rownumcte
where row_num>1
--order by PropertyAddress

with rownumcte as(
select *, 
ROW_NUMBER() over(
partition by parcelID,
             propertyAddress,
			 salePrice,
			 saleDate,
			 LegalReference
			 order by 
			 UniqueId
			 ) row_num
		
from [PORTFOLIO PROJECT]..nashvillehousing
)
select *
from rownumcte
where row_num>1
order by PropertyAddress

