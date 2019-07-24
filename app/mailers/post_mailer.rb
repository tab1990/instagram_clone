class PostMailer < ApplicationMailer
  default from: 'from@example.com'
  layout 'mailer'

  def post_mail(post)
    @post = post

    mail to: @post.user.email, subject: '【instagram_clone】投稿のお知らせ'
  end
end
