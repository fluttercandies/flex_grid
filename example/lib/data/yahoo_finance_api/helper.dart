import 'package:uuid/uuid.dart';

class Helper {
  const Helper._();
  static final DateTime epoch = DateTime(1970, 1, 1, 0, 0, 0);

  /* static final TimeZoneInfo TzEst = TimeZoneInfo
            .GetSystemTimeZones()
            .Single(tz => tz.Id == "Eastern Standard Time" || tz.Id == "America/New_York");

        private static DateTime ToUtcFrom(this DateTime dt, TimeZoneInfo tzi) =>
            TimeZoneInfo.ConvertTimeToUtc(dt, tzi);

        internal static DateTime FromEstToUtc(this DateTime dt) =>
            DateTime.SpecifyKind(dt, DateTimeKind.Unspecified)
               .ToUtcFrom(TzEst);

        internal static string ToUnixTimestamp(this DateTime dt) =>
            DateTime.SpecifyKind(dt, DateTimeKind.Utc)
                .Subtract(Epoch)
                .TotalSeconds
                .ToString("F0");
 */

  static String getRandomString(int length) => Uuid().v1().substring(0, length);

  // internal static IEnumerable<string> Duplicates(this IEnumerable<string> items)
  // {
  //     var hashSet = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
  //     return items.Where(item => !hashSet.Add(item));
  // }

}

extension StringExtension on String {
  String toLowerCamel() => substring(0, 1).toLowerCase() + substring(1);

  String toPascal() => substring(0, 1).toUpperCase() + substring(1);
}

extension DateTimeExtension on DateTime {
//DateTime get sss=>this.toUtc()
}
