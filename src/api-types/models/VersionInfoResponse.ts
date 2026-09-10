/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */

import type { Version } from './Version';

export type VersionInfoResponse = {
    version_info: Version;
    downloader_info?: {
        selected_fork: string;
        forks: Record<string, {version?: string; downloader?: string; path?: string; exec?: string}>;
    };
};
