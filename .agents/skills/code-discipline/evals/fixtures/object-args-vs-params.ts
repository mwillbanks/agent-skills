// Scenario: a report builder helper has grown multiple optional positional params.
// This should be shaped as an options object, not a positional sprawl helper.

export function buildUsageReport(
  accountId: string,
  startDate?: string,
  endDate?: string,
  includeDrafts?: boolean,
  timezone?: string,
  locale?: string,
) {
  return {
    accountId,
    startDate,
    endDate,
    includeDrafts,
    timezone,
    locale,
  };
}
