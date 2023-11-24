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
  parse(
    {
      trig = "unique",
      desc = "Remove duplicates, get unique elements",
    },
    [[
    std::sort(${1}.begin(), ${1}.end());
    a.erase(std::unique(${1}.begin(), ${1}.end()), ${1}.end());
    ]]
  ),
  parse(
    {
      trig = "next_permutation",
      desc = "Get all permutations",
    },
    [[
      std::sort(${1}.begin(), ${1}.end());
      do {
        for (auto i : ${1}) {
          cout << i << " ";
        }
        cout << endl;

      } while (std::next_permutation(${1}.begin(), ${1}.end()));
    ]]
  ),
  parse({
    trig = "inf",
    desc = "the inf constant",
  }, " #define inf 0x3f3f3f3f"),
}
