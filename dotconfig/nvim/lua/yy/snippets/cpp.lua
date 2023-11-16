return {
  parse(
    "#inca",
    [[
#include <bits/stdc++.h>

using namespace std;

int main() {
  cin.sync_with_stdio(false);
  cin.tie(nullptr);
  cout.tie(nullptr);
  int n;
  cin >> n;
  $1
  return 0;
}
    ]]
  ),
  parse(
    {
      trig = "freopen",
      desc = "Redirect stdin and stdout",
    },
    [[
freopen("${1:test}.in", "r", stdin);
freopen("${2:test}.out", "w", stdout);
    ]]
  ),
  parse(
    {
      trig = "fclose",
      desc = "Close stdin and stdout",
    },
    [[
fclose(stdin);
fclose(stdout);
    ]]
  ),
}
