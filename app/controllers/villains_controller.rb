class VillainsController < ApplicationController
    def list
        swears = list_swears
        @villains = User.joins(:pastes).where{pastes.content.like_any swears}.group{id}
    end

private

    def list_swears
        seven_dirty_words = ['shit', 'piss', 'fuck', 'cunt', 'cocksucker', 'motherfucker', 'tits']
        dirty_words = ['bitch']
        [seven_dirty_words, dirty_words].flatten.collect{|w| "%#{w}%"}
    end
end
