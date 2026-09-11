import { HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

// Angular's built-in XSRF interceptor only attaches the X-XSRF-TOKEN header to requests
// made with a relative URL - it treats any absolute URL as cross-origin and skips it.
// This app always calls the API via an absolute URL (see PostsService.path), so that
// built-in behavior never kicks in. This interceptor replicates it manually: it reads
// the XSRF-TOKEN cookie set by the backend (lusca) and attaches it as a header on every
// state-changing request, and marks requests as `withCredentials` so the browser stores
// and sends that cookie across the frontend/backend origins (different ports).
//
// Scoped to our own API only (URL contains '/api/', PostsService's path convention) -
// applying withCredentials/headers to third-party calls (e.g. the GitHub release check)
// would break them, since a server replying with a wildcard Access-Control-Allow-Origin
// rejects credentialed requests outright.
@Injectable()
export class XsrfInterceptor implements HttpInterceptor {

    intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        if (!request.url.includes('/api/')) {
            return next.handle(request);
        }

        let cloned = request.clone({ withCredentials: true });

        if (!/^(GET|HEAD)$/.test(cloned.method)) {
            const token = this.getCookie('XSRF-TOKEN');
            if (token) {
                cloned = cloned.clone({ headers: cloned.headers.set('X-XSRF-TOKEN', token) });
            }
        }

        return next.handle(cloned);
    }

    private getCookie(name: string): string | null {
        const match = document.cookie.match(new RegExp('(?:^|; )' + name + '=([^;]*)'));
        return match ? decodeURIComponent(match[1]) : null;
    }
}
