import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { CosmosClient } from "@azure/cosmos";
import { DefaultAzureCredential } from "@azure/identity";

export async function db(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    context.log(`Http function processed request for url "${request.url}"`);

    try {
        const client = new CosmosClient({
            endpoint: process.env.COSMOSDB_ENDPOINT,
            aadCredentials: new DefaultAzureCredential(),
        });
    
        const { database } = await client.databases.createIfNotExists({ id: 'testdb' });
        const { container } = await database.containers.createIfNotExists({ id: 'testcontainer' });
        const { resource: created } = await container.items.create({ message: 'Hello from CosmosDB' });
        const { resource } = await container.item(created.id).read();
    
        return { body: JSON.stringify(resource) };
    } catch (error) {
        context.error(error);
        return { status: 500, body: `Internal Server Error: ${error.toString()}` };
    }
};

app.http('db', {
    methods: ['GET'],
    authLevel: 'anonymous',
    handler: db
});
