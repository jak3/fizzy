require "spec_helper"


describe Fizzy::Sync do

  include_context :docker

  describe "#available" do
    subject { Fizzy::Sync.available }
    it { is_expected.to be_kind_of(Array) }
    it { is_expected.to_not be_empty }
  end

  describe "#enabled" do
    context "when remote starts with `git:`" do
      subject { Fizzy::Sync.enabled(Pathname.new("foo"), "git:bar") }
      it { expect(subject.size).to eq(1) }
      it { expect(subject.first).to be_kind_of(Fizzy::Sync::Git) }
    end

    context "when remote is an existing directory" do
      skip unless in_docker?

      before do
        @dir_path = Dir.mktmpdir("foo")
      end

      after do
        FileUtils.rm_r(@dir_path)
      end

      subject { Fizzy::Sync.enabled(Pathname.new("foo"), @dir_path) }
      it { is_expected.to include(a_kind_of Fizzy::Sync::Local) }
    end
  end

  describe "#selected" do
    context "when a remote url" do
      %w(git:foobar foobar).each do |remote_url|
        context "`#{remote_url}` that selects `git` sync is provided" do
          subject { Fizzy::Sync.selected(Pathname.new("foo"), remote_url) }
          it { is_expected.to be_kind_of(Fizzy::Sync::Git) }
        end
      end

      context "that selects `local` sync is provided" do
        skip unless in_docker?

        before do
          @dir_path = Dir.mktmpdir("foo")
        end

        after do
          FileUtils.rm_r(@dir_path)
        end

        subject { Fizzy::Sync.selected(Pathname.new("foo"), @dir_path) }
        it { is_expected.to be_kind_of(Fizzy::Sync::Local) }
      end
    end
  end

end
