import { CloudFrontClient, ListCachePoliciesCommand } from "@aws-sdk/client-cloudfront";
export const handler = async (event) => {
    const client = new CloudFrontClient({region: 'eu-north-1'});
    const input = {
        Type: "managed"
    };
    const command = new ListCachePoliciesCommand(input);
    const response = await client.send(command);
    console.log("Success", response);
    console.log(JSON.stringify(response, null, 2));
    return response;
};