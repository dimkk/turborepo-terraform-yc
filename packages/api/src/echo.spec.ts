import test from 'ava';
import { echo } from './echo';

test('echo returns echo', (t) => {
    const result = echo.handler(
        {
            httpMethod: 'GET',
            queryStringParameters: { echo: 'supertest' },
        } as any,
        {} as any
    ) as any;
    t.is(result.body, 'supertest1');
});
