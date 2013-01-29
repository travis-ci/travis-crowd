require 'twitter'

followers = %w(travisci j2h konstantinhaase svenfuchs).inject([]) do |ids, handle|
  cursor = '-1'
  while cursor != 0 do
    followers = Twitter.follower_ids(handle, :cursor => cursor)
    ids += followers.ids || []
    cursor = followers.next_cursor
    sleep(2)
  end
  ids
end.uniq

p followers.size
