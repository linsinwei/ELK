# XSG.ATCity.ApiService

## Models
ApiInputViewModel: Api Request content  
* command: Strategy Name  
* data: Request JSON data  
* product: Product Type，目前沒用到  

ApiOutputViewModel: Api Responce content
* result_code
* result_message
* result_data: Responce JSON Data

RequestCountOutputModel: Compute the number of requests 
* Count: 目前/已處理完的Request數量

StorageOutputModel: 
result_code
result_message
file_name: 上傳完成的檔名
club_id: 俱樂部ID

---

## Apis
CallController: Not Encrypted Api  
CalleController: Encrypted Api  
FileStorageController: Upload/Delete Image File Api

---

## Strategy
StrategyFactory  
IStrategy 實作以下策略: 

Encrypted  
* PostDeviceInfo

## 新增章魚變數

ApiService_ApiURL