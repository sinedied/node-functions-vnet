import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { CosmosClient } from "@azure/cosmos";
import { DefaultAzureCredential } from "@azure/identity";

export async function hello(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    context.log(`Http function processed request for url "${request.url}"`);

    const name = request.query.get('name') || await request.text() || 'world';
    let response = `Hello ${name} from API!`;

    try {
        const client = new CosmosClient({
            endpoint: process.env.COSMOSDB_ENDPOINT,
            aadCredentials: new DefaultAzureCredential(),
        });
    
        const { database } = await client.databases.createIfNotExists({ id: 'testdb' });
        const { container } = await database.containers.createIfNotExists({ id: 'testcontainer' });
        const { resource } = await container.items.upsert({ id: '0', message: 'Hello world from CosmosDB!' });
    
        response += `<br>${resource.message}`;
    } catch (error) {
        context.error(error);
        response += `<br>Error while fetching CosmosDB data: ${error.toString()}`;
    }

    return { body: response };
};

app.http('hello', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: hello
});
