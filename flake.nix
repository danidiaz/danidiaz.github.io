{
  # https://nix.dev/anti-patterns/language#unquoted-urls
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, ... }@attrs:
    # https://discourse.nixos.org/t/using-nixpkgs-legacypackages-system-vs-import/17462/5
    # https://discourse.nixos.org/t/recommendations-for-use-of-flakes-input-follows/17413
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-fmt.html
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      # https://blog.ysndr.de/posts/guides/2021-12-01-nix-shells/#development-environments
      # is 'devShell' (singular) actually wrong?
      # https://nixos.wiki/wiki/Flakes
      # https://ryantm.github.io/nixpkgs/builders/special/mkshell/
      devShells.x86_64-linux.default = pkgs.mkShell {
        # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/ruby.section.md
        buildInputs = [
          (pkgs.ruby.withPackages (ps: [ 
            ps.jekyll 
            ps.minima 
            ps.github-pages 
            ps.jekyll-coffeescript
            ps.jekyll-default-layout
            ps.jekyll-gist
            ps.jekyll-github-metadata
            ps.jekyll-optional-front-matter
            ps.jekyll-paginate
            ps.jekyll-readme-index
            ps.jekyll-titles-from-headings
            ps.jekyll-relative-links 
            ]))
          pkgs.haskellPackages.wai-app-static
        ];
      };
    };
  nixConfig = {
    # https://nixos.wiki/wiki/Flakes#Setting_the_bash_prompt_like_nix-shell
    bash-prompt-prefix = "[develop] ";
  };
}