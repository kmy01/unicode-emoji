require_relative "../lib/unicode/emoji"
require "minitest/autorun"

describe Unicode::Emoji do
  describe ".properties" do
    it "will return an Array with Emoji properties if codepoints has some" do
      assert_equal ["Emoji", "Emoji_Presentation"], Unicode::Emoji.properties("😴")
      assert_equal ["Emoji"], Unicode::Emoji.properties("♠")
    end

    it "will return nil with Emoji properties if codepoints has some" do
      assert_nil Unicode::Emoji.properties("A")
    end
  end

  describe "REGEX" do
    it "matches most singleton emoji codepoints" do
      "😴 sleeping face" =~ Unicode::Emoji::REGEX
      assert_equal "😴", $&
    end

    it "matches singleton emoji in combination with emoji variation selector" do
      "😴\u{FE0F} sleeping face" =~ Unicode::Emoji::REGEX
      assert_equal "😴\u{FE0F}", $&
    end

    it "does not match singleton emoji when in combination with text variation selector" do
      "😴\u{FE0E} sleeping face" =~ Unicode::Emoji::REGEX
      assert_nil $&
    end

    it "does not match textual singleton emoji" do
      "▶ play button" =~ Unicode::Emoji::REGEX
      assert_nil $&
    end

    it "does match textual singleton emoji in combination with emoji variation selector" do
      "▶\u{FE0F} play button" =~ Unicode::Emoji::REGEX
      assert_equal "▶\u{FE0F}", $&
    end

    it "does not match singleton 'component' emoji codepoints" do
      "🏻 light skin tone" =~ Unicode::Emoji::REGEX
      assert_nil $&
    end

    it "does match modified emoji if modifier base emoji is used" do
      "🛌🏽 person in bed: medium skin tone" =~ Unicode::Emoji::REGEX
      assert_equal "🛌🏽", $&
    end

    it "does not match modified emoji if no modifier base emoji is used" do
      "🌵🏽 cactus" =~ Unicode::Emoji::REGEX
      assert_equal "🌵", $&
    end

    it "does match valid region flags" do
      "🇵🇹 Portugal" =~ Unicode::Emoji::REGEX
      assert_equal "🇵🇹", $&
    end

    it "does not match invalid region flags" do
      "🇵🇵 PP Land" =~ Unicode::Emoji::REGEX
      assert_nil $&
    end

    it "does match emoji keycap sequences" do
      "2️⃣ keycap: 2" =~ Unicode::Emoji::REGEX
      assert_equal "2️⃣", $&
    end

    it "does match recommended tag sequences" do
      "🏴󠁧󠁢󠁳󠁣󠁴󠁿 Scotland" =~ Unicode::Emoji::REGEX
      assert_equal "🏴󠁧󠁢󠁳󠁣󠁴󠁿", $&
    end

    it "does not match valid tag sequences which are not recommended" do
      "🏴󠁧󠁢󠁡󠁧󠁢󠁿 GB AGB" =~ Unicode::Emoji::REGEX
      assert_equal "🏴", $& # only base flag is matched
    end

    it "does match recommended zwj sequences" do
      "🤾🏽‍♀️ woman playing handball: medium skin tone" =~ Unicode::Emoji::REGEX
      assert_equal "🤾🏽‍♀️", $&
    end

    it "does not match valid zwj sequences which are not recommended" do
      "🤠‍🤢 vomiting cowboy" =~ Unicode::Emoji::REGEX
      assert_equal "🤠", $&
    end
  end

  describe "REGEX_VALID" do
    it "matches most singleton emoji codepoints" do
      "😴 sleeping face" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "😴", $&
    end

    it "matches singleton emoji in combination with emoji variation selector" do
      "😴\u{FE0F} sleeping face" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "😴\u{FE0F}", $&
    end

    it "does not match singleton emoji when in combination with text variation selector" do
      "😴\u{FE0E} sleeping face" =~ Unicode::Emoji::REGEX_VALID
      assert_nil $&
    end

    it "does not match textual singleton emoji" do
      "▶ play button" =~ Unicode::Emoji::REGEX_VALID
      assert_nil $&
    end

    it "does match textual singleton emoji in combination with emoji variation selector" do
      "▶\u{FE0F} play button" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "▶\u{FE0F}", $&
    end

    it "does not match singleton 'component' emoji codepoints" do
      "🏻 light skin tone" =~ Unicode::Emoji::REGEX_VALID
      assert_nil $&
    end

    it "does match modified emoji if modifier base emoji is used" do
      "🛌🏽 person in bed: medium skin tone" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "🛌🏽", $&
    end

    it "does not match modified emoji if no modifier base emoji is used" do
      "🌵🏽 cactus" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "🌵", $&
    end

    it "does match valid region flags" do
      "🇵🇹 Portugal" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "🇵🇹", $&
    end

    it "does not match invalid region flags" do
      "🇵🇵 PP Land" =~ Unicode::Emoji::REGEX_VALID
      assert_nil $&
    end

    it "does match emoji keycap sequences" do
      "2️⃣ keycap: 2" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "2️⃣", $&
    end

    it "does match recommended tag sequences" do
      "🏴󠁧󠁢󠁳󠁣󠁴󠁿 Scotland" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "🏴󠁧󠁢󠁳󠁣󠁴󠁿", $&
    end

    it "does match valid tag sequences, even though they are not recommended" do
      "🏴󠁧󠁢󠁡󠁧󠁢󠁿 GB AGB" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "🏴󠁧󠁢󠁡󠁧󠁢󠁿", $&
    end

    it "does not match invalid tag sequences" do
      "🏴󠁧󠁢󠁡󠁡󠁡󠁿 GB AAA" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "🏴", $&
    end

    it "does match recommended zwj sequences" do
      "🤾🏽‍♀️ woman playing handball: medium skin tone" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "🤾🏽‍♀️", $&
    end

    it "does match valid zwj sequences, even though they are not recommended" do
      "🤠‍🤢 vomiting cowboy" =~ Unicode::Emoji::REGEX_VALID
      assert_equal "🤠‍🤢", $&
    end
  end

  describe "REGEX_BASIC" do
    it "matches most singleton emoji codepoints" do
      "😴 sleeping face" =~ Unicode::Emoji::REGEX_BASIC
      assert_equal "😴", $&
    end

    it "matches singleton emoji in combination with emoji variation selector" do
      "😴\u{FE0F} sleeping face" =~ Unicode::Emoji::REGEX_BASIC
      assert_equal "😴\u{FE0F}", $&
    end

    it "does not match singleton emoji when in combination with text variation selector" do
      "😴\u{FE0E} sleeping face" =~ Unicode::Emoji::REGEX_BASIC
      assert_nil $&
    end

    it "does not match textual singleton emoji" do
      "▶ play button" =~ Unicode::Emoji::REGEX
      assert_nil $&
    end

    it "does match textual singleton emoji in combination with emoji variation selector" do
      "▶\u{FE0F} play button" =~ Unicode::Emoji::REGEX
      assert_equal "▶\u{FE0F}", $&
    end

    it "does not match singleton 'component' emoji codepoints" do
      "🏻 light skin tone" =~ Unicode::Emoji::REGEX_BASIC
      assert_nil $&
    end

    it "does not match modified emoji" do
      "🛌🏽 person in bed: medium skin tone" =~ Unicode::Emoji::REGEX_BASIC
      assert_equal "🛌", $&
    end

    it "does not match region flags" do
      "🇵🇹 Portugal" =~ Unicode::Emoji::REGEX_BASIC
      assert_nil $&
    end

    it "does not match emoji keycap sequences" do
      "2️⃣ keycap: 2" =~ Unicode::Emoji::REGEX_BASIC
      assert_nil $&
    end

    it "does not match tag sequences" do
      "🏴󠁧󠁢󠁳󠁣󠁴󠁿 Scotland" =~ Unicode::Emoji::REGEX_BASIC
      assert_equal "🏴", $& # only base flag is matched
    end

    it "does not match zwj sequences" do
      "🤾🏽‍♀️ woman playing handball: medium skin tone" =~ Unicode::Emoji::REGEX_BASIC
      assert_equal "🤾", $&
    end
  end

  describe "REGEX_TEXT" do
    it "deos not match singleton emoji codepoints with emoji presentation and no variation selector" do
      "😴 sleeping face" =~ Unicode::Emoji::REGEX_TEXT
      assert_nil $&
    end

    it "does not match singleton emoji in combination with emoji variation selector" do
      "😴\u{FE0F} sleeping face" =~ Unicode::Emoji::REGEX_TEXT
      assert_nil $&
    end

    it "does match singleton emoji in combination with text variation selector" do
      "😴\u{FE0E} sleeping face" =~ Unicode::Emoji::REGEX_TEXT
      assert_equal "😴\u{FE0E}", $&
    end

    it "does match textual singleton emoji" do
      "▶ play button" =~ Unicode::Emoji::REGEX_TEXT
      assert_equal "▶", $&
    end

    it "does not match textual singleton emoji in combination with emoji variation selector" do
      "▶\u{FE0F} play button" =~ Unicode::Emoji::REGEX_TEXT
      assert_nil $&
    end

    it "does not match singleton 'component' emoji codepoints" do
      "🏻 light skin tone" =~ Unicode::Emoji::REGEX_TEXT
      assert_nil $&
    end

    it "does not match modified emoji" do
      "🛌🏽 person in bed: medium skin tone" =~ Unicode::Emoji::REGEX_TEXT
      assert_nil $&
    end

    it "does not match region flags" do
      "🇵🇹 Portugal" =~ Unicode::Emoji::REGEX_TEXT
      assert_nil $&
    end

    it "does not match emoji keycap sequences" do
      "2️⃣ keycap: 2" =~ Unicode::Emoji::REGEX_TEXT
      assert_nil $&
    end

    it "does not match tag sequences" do
      "🏴󠁧󠁢󠁳󠁣󠁴󠁿 Scotland" =~ Unicode::Emoji::REGEX_TEXT
      assert_nil $&
    end

    it "does not match zwj sequences" do
      "🤾🏽‍♀️ woman playing handball: medium skin tone" =~ Unicode::Emoji::REGEX_TEXT
      assert_nil $&
    end
  end

  describe "REGEX_ANY" do
    it "returns any emoji-related codepoint (but no variation selectors or tags)" do
      matches = "1 string 😴\u{FE0F} sleeping face with 🇵 and modifier 🏾, also 🏴󠁧󠁢󠁳󠁣󠁴󠁿 Scotland".scan(Unicode::Emoji::REGEX_ANY)
      assert_equal ["1", "😴", "🇵", "🏾", "🏴"], matches
    end
  end

  describe ".list" do
    it "returns a grouped list of emoji" do
      assert_includes Unicode::Emoji.list.keys, "Smileys & People"
    end

    it "sub-groups the list of emoji" do
      assert_includes Unicode::Emoji.list("Smileys & People").keys, "face-positive"
    end

    it "has emoji in sub-groups" do
      assert_includes Unicode::Emoji.list("Smileys & People", "face-positive"), "😎"
    end
  end
end
