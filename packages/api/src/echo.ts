import { HttpRoute } from 'yandex-cloud-functions-router';

export const echo: HttpRoute = {
    httpMethod: ['GET'],
    params: {
        echo: {
            type: 'regexp',
            value: '*',
        },
    },
    handler: (event, context) => {
        // Handle /?echo=any
        console.log({ event, context });

        return {
            body: event.queryStringParameters.echo,
            statusCode: 200,
        };
    },
};
