# -*- coding: utf-8 -*-

require 'rspec'
require './java_version.rb'

describe JavaVersion do

  describe "#valid?" do

    it "'JDK[ファミリー番号]u[アップデート番号]'が渡された時、trueを返す" do
      JavaVersion.valid?("JDK7u40").should be_true
    end

    it "'JDK[ファミリー番号]u[アップデート番号]'以外が渡された時、falseを返す" do
      JavaVersion.valid?("hoge").should be_false
      JavaVersion.valid?("fuga").should be_false
    end

    it "バージョン番号が整数でない時、falseを返す" do
      JavaVersion.valid?("JDK7.1u3").should be_false
      JavaVersion.valid?("JDK7u3.1").should be_false
    end

  end
  
  describe "#parse" do

    it "書式が正しくない場合、例外を発生させる" do
      expect {
        JavaVersion.parse("JDK7.1u3")
      }.to raise_error(JavaVersion::VersionFormatError)
    end
    
    it "書式が正しい場合、ファミリー番号を返す" do
      v = JavaVersion.parse("JDK7u40")
      v.family_number.should eq(7)

      v = JavaVersion.parse("JDK6u40")
      v.family_number.should eq(6)
    end

    it "書式が正しい場合、アップデート番号を返す" do
      v = JavaVersion.parse("JDK7u40")
      v.update_number.should eq(40)
    end

  end

  describe "#lt" do
    context "受け取ったJavaVersionオブジェクトのファミリー番号を比較して" do
      before do
        @jdk7u40 = JavaVersion.parse('JDK7u40')
        @jdk8u20 = JavaVersion.parse('JDK8u20')
      end

      it "自身のファミリー番号が小さかった場合、trueを返す" do
        @jdk7u40.lt(@jdk8u20).should be_true
      end

      it "自身のファミリー番号が大きかった場合、falseを返す" do
        @jdk8u20.lt(@jdk7u40).should be_false
      end

      context "自身のファミリー番号と等しかった場合、アップデート番号を比較して" do
        it "自身のアップデート番号が小さかった場合、trueを返す" do
          jdk7u80 = JavaVersion.parse('JDK7u80')
          @jdk7u40.lt(jdk7u80).should be_true
        end

        it "自身のアップデート番号が大きかった場合、falseを返す" do
          jdk7u20 = JavaVersion.parse('JDK7u20')
          @jdk7u40.lt(jdk7u20).should be_false
        end

        it "自身のアップデート番号と等しかった場合、falseを返す" do
          @jdk7u40.lt(@jdk7u40).should be_false
        end
      end
    end
  end

  describe "#gt" do
    context "受け取ったJavaVersionオブジェクトのファミリー番号を比較して" do
      before do
        @jdk7u40 = JavaVersion.parse('JDK7u40')
        @jdk8u20 = JavaVersion.parse('JDK8u20')
      end

      it "自身のファミリー番号が小さかった場合、falseを返す" do
        @jdk7u40.gt(@jdk8u20).should be_false
      end

      it "自身のファミリー番号が大きかった場合、trueを返す" do
        @jdk8u20.gt(@jdk7u40).should be_true
      end

      context "自身のファミリー番号と等しかった場合、アップデート番号を比較して" do
        it "自身のアップデート番号が小さかった場合、falseを返す" do
          jdk7u80 = JavaVersion.parse('JDK7u80')
          @jdk7u40.gt(jdk7u80).should be_false
        end

        it "自身のアップデート番号が大きかった場合、trueを返す" do
          jdk7u20 = JavaVersion.parse('JDK7u20')
          @jdk7u40.gt(jdk7u20).should be_true
        end

        it "自身のアップデート番号と等しかった場合、falseを返す" do
          @jdk7u40.gt(@jdk7u40).should be_false
        end
      end
    end
  end

  describe "#next_limited_update" do
    it "次のLimitedUpdate番号になる" do
      jdk6u20 = JavaVersion.parse('JDK6u20')
      jdk6u20.next_limited_update().update_number.should eq(40)
      jdk6u21 = JavaVersion.parse('JDK6u21')
      jdk6u21.next_limited_update().update_number.should eq(40)
    end
  end
end