/**
 * @description       : Service class containing methods to clear storage by deleting unused badges and debug logs created by the Trail Tracker app.
 * @author            : Ben Learn
 * @last modified on  : 01-08-2023
 * @last modified by  : Ben Learn
**/
public with sharing class StorageManagementService {
    /**
    * @description Method to clean storage by removing unused badges, trails, debug logs, and trailmixes.
    * @author Ben Learn | 03-13-2022 
    **/
    public static List<String> clean() {
        return service().clean();
    }

    private static IStorageManagementService service() {
        return (IStorageManagementService) Application.Service.newInstance(IStorageManagementService.class);
    }
}
