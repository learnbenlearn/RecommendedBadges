@isTest
public class CustomHttpCalloutMock implements HttpCalloutMock {
    private String response;
    private String responseStatus;
    private Integer responseStatusCode;

    @SuppressWarnings('PMD.ApexDoc')
    public CustomHttpCalloutMock(String response, Integer responseStatusCode) {
        this(response, responseStatusCode, null);
    }

    @SuppressWarnings('PMD.ApexDoc')
    public CustomHttpCalloutMock(String response, Integer responseStatusCode, String responseStatus) {
        this.response = response;
        this.responseStatusCode = responseStatusCode;
        this.responseStatus = responseStatus;
    }

    @SuppressWarnings('PMD.ApexDoc')
    public HttpResponse respond(HttpRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(this.response);
        response.setStatusCode(this.responseStatusCode);
        response.setStatus(this.responseStatus ?? '');
        return response;
    }
}